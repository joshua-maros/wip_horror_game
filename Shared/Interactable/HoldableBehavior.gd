extends Behavior

class_name HoldableBehavior

var contained_in: ContainerBehavior = null
@export var display_mesh: Mesh = null
@export var label: StringName

func can_pick_up() -> bool:
	return true

func _ready():
	super._ready()
	_connect_to_parent_signals()
	if display_mesh == null:
		_use_default_mesh()

func _connect_to_parent_signals():
	parent.interact_start.connect(_pick_up)

func _use_default_mesh():
	for child in parent.get_children():
		if child is MeshInstance3D:
			display_mesh = child.mesh
			break

func _pick_up(player: Player):
	if can_pick_up():
		player.hand_handler.start_holding(self)
