extends Behavior

class_name HighlightOnHoverBehavior

@export var mesh_root: Node3D
@onready var meshes: Array[MeshInstance3D] = []

func _ready():
	super._ready()
	connect_to_parent_signals()
	if mesh_root == null:
		mesh_root = get_parent()
	add_meshes_from(mesh_root)

func add_meshes_from(node: Node):
	if node is MeshInstance3D:
		meshes.push_back(node)
	for child in node.get_children():
		add_meshes_from(child)

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
