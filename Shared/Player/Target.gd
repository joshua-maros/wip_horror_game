extends RefCounted

class_name Target

var collider: StaticBody3D
var position: Vector3
var target: Interactable = null

# c is a StaticBody3D, but due to a bug we cannot annotate it as such
# (https://github.com/godotengine/godot/issues/67105)
func _init(c, p: Vector3):
	collider = c
	position = p
	if collider == null:
		return
	target = Util.get_parent_interactable(collider)

func interactable() -> Interactable:
	return target

func container() -> ContainerBehavior:
	if target:
		for behavior in target.behaviors:
			if behavior is ContainerBehavior:
				return behavior
	return null
		
