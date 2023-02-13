extends RefCounted

const ContainerBehavior = \
	preload("res://Shared/Interactables/ContainerBehavior.gd")
const Hoverable = preload("res://Shared/Interactables/Hoverable.gd")
const InteractableBehavior = \
	preload("res://Shared/Interactables/InteractableBehavior.gd")
const MovableBehavior = preload("res://Shared/Interactables/MovableBehavior.gd")

var collider: StaticBody3D
var position: Vector3
var target: Hoverable = null

# c is a StaticBody3D, but due to a bug we cannot annotate it as such
# (https://github.com/godotengine/godot/issues/67105)
func _init(c, p: Vector3):
	collider = c
	position = p
	if collider == null:
		return
	target = Util.get_parent_hoverable(collider)

func target_movable() -> MovableBehavior:
	if target == null:
		return null
	for child in target.get_children():
		if child is MovableBehavior:
			return child as MovableBehavior
	return null

func target_interactable() -> InteractableBehavior:
	if target == null:
		return null
	for child in target.get_children():
		if child is InteractableBehavior:
			return child as InteractableBehavior
	return null

func target_container() -> ContainerBehavior:
	if target == null:
		return null
	for child in target.get_children():
		if child is ContainerBehavior:
			return child as ContainerBehavior
	return null
