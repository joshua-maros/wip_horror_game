extends RefCounted

var collider: StaticBody3D
var position: Vector3
var target: Node3D = null

# c is a StaticBody3D, but due to a bug we cannot annotate it as such
# (https://github.com/godotengine/godot/issues/67105)
func _init(c, p: Vector3):
	collider = c
	position = p
	if collider == null:
		return
	target = collider.get_parent_node_3d()
