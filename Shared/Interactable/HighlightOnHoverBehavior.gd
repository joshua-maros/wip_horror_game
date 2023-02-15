extends Behavior

class_name HighlightOnHoverBehavior

@export var mesh: MeshInstance3D
@onready var meshes = [mesh]

func _ready():
	super._ready()
	connect_to_parent_signals()
	if meshes.size() == 0:
		use_default_meshes()

func connect_to_parent_signals():
	parent.hover_start.connect(highlight_start)
	parent.hover_stop.connect(highlight_stop)

func use_default_meshes():
	for child in parent.get_children():
		if child is MeshInstance3D:
			meshes.push_back(child)

func highlight_start(_player: Player):
	for mesh in meshes:
		mesh.material_override = Constants.cursor_mat

func highlight_stop(_player: Player):
	for mesh in meshes:
		mesh.material_override = null
