extends RefCounted

class_name HandHandler

var _anim_sys: HandAnimationSystem = HandAnimationSystem.new()
var _currently_holding: HoldableBehavior = null
var _place_cursor = MeshInstance3D.new()
var _player: Player

func start_holding(holdable: HoldableBehavior):
	if holdable.contained_in:
		var obj = holdable.parent
		var transform = obj.global_transform
		var root = obj.get_tree().root.get_child(0)
		obj.get_parent().remove_child(obj)
		root.add_child(obj)
		obj.global_transform = transform
		holdable.contained_in.start_removing(holdable)
		holdable.contained_in = null
	_pick_up_object(holdable)

func start_interacting():
	var target := _player.target
	if _currently_holding:
		var c := target.container()
		if c and c.can_take(_currently_holding):
			var anim := InsertAnim.new(c)
			_anim_sys.start(anim, _currently_holding.parent)
			_currently_holding.contained_in = c
			c.start_taking(_currently_holding)
			_currently_holding = null
			_player.hover_handler._stop_hovering_previous_object()
		elif _has_placeable_anywhere_behavior(_currently_holding.parent) \
			and target.hit_object:
			var obj = _currently_holding.parent
			var anim := PutDownAnim.new( \
				Transform3D.IDENTITY.translated(target.position))
			_anim_sys.start(anim, obj)
			_currently_holding = null
			_player.hover_handler._stop_hovering_previous_object()
	elif target.interactable():
		target.interactable().start_interacting(_player)

func _has_placeable_anywhere_behavior(i: Interactable) -> bool:
	for b in i.behaviors:
		if b is PlaceableAnywhereBehavior:
			return true
	return false

func stop_interacting():
	if !_currently_holding:
		var target = _player.target.interactable()
		if target:
			target.stop_interacting(_player)

func _init(p: Player):
	_player = p

func _ready():
	_place_cursor.set_name("PlaceCursor")
	# _place_cursor.material_override = Constants.cursor_mat
	var root = _player.held_parent.get_tree().root.get_child(0)
	root.call_deferred("add_child", _place_cursor)

func _process(delta):
	_anim_sys.process(delta)

func _pick_up_object(holdable: HoldableBehavior):
	_anim_sys.start(PickUpAnim.new(_player.held_parent), holdable.parent)
	_currently_holding = holdable

func _update_place_cursor(target: Target):
	if _currently_holding == null:
		_place_cursor.hide()
	else:
		_place_cursor.show()
		_place_cursor.position = target.position
		_place_cursor.mesh = _currently_holding.display_mesh
