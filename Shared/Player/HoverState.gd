extends RefCounted

const HandState = preload("HandState.gd")
const Hoverable = preload("res://Shared/Interactables/Hoverable.gd")
const Target = preload("Target.gd")
const Slot = preload("res://Shared/Interactables/Slot.gd")

var hand_state: HandState
var last_hovered: Array = []

func _init(h: HandState):
	hand_state = h

func physics_process(t: Target):
	var now_hovering_root = get_hovering_root(t)
	var now_hovering = collect_object_and_holding(now_hovering_root)
	set_hovering(now_hovering)
	
func get_hovering_root(t: Target):
	if hand_state.holding != null:
		if not t.target is Slot:
			return null
		elif not (t.target as Slot).can_insert(hand_state.holding):
			return null
	elif t.target is Slot and t.target.locked:
		return null
	return t.target

func collect_object_and_holding(obj: Hoverable):
	if obj == null:
		return []
	elif hand_state.animations.currently_animating(obj):
		return []
	elif obj is Slot:
		var result = collect_object_and_holding((obj as Slot).contents)
		result.append(obj)
		return result
	else:
		return [obj]

func set_hovering(now_hovering: Array):
	for obj in now_hovering:
		if not last_hovered.has(obj):
			start_hovering(obj)
	for obj in last_hovered:
		if not now_hovering.has(obj):
			stop_hovering(obj)
	last_hovered = now_hovering

func start_hovering(obj: Hoverable):
	obj.on_hover_start()

func stop_hovering(obj: Hoverable):
	obj.on_hover_end()
