extends RefCounted

class_name Target

var position: Vector3
var target: Interactable = null

# c is a StaticBody3D, but due to a bug we cannot annotate it as such
# (https://github.com/godotengine/godot/issues/67105)
func _init(collider, p: Vector3):
	position = p
	if collider == null:
		return
	target = Util.get_parent_interactable(collider)
	if target:
		while target.glued_to:
			target = target.glued_to

func interactable() -> Interactable:
	return target

func container() -> ContainerBehavior:
	if target:
		for behavior in target.behaviors:
			if behavior is ContainerBehavior:
				return behavior
	return null
		
