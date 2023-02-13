extends Node

const Hoverable = preload("res://Shared/Interactables/Hoverable.gd")
const ContainerBehavior = preload("res://Shared/Interactables/ContainerBehavior.gd")

func enable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody3D:
			(child as StaticBody3D).collision_layer = 2

func disable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody3D:
			(child as StaticBody3D).collision_layer = 0

# search_start is Node, but due to a bug we cannot annotate it as such.
# (https://github.com/godotengine/godot/issues/67105)
func get_parent_with_class_impl(search_start, clas) -> Node:
	if search_start == null:
		return null
	elif search_start is clas:
		return search_start
	else:
		return get_parent_with_class_impl(search_start.get_parent(), clas)
		
# Get parent with class, only used to implement other methods.
func get_parent_with_class(search_start: Node, clas, clas_name: String) -> Node:
	var result = get_parent_with_class_impl(search_start, clas)
	# assert(result != null, str(search_start) + " does not have a " \
	# 	+ clas_name + " as a parent.")
	return result

func get_parent_hoverable(search_start: Node) -> Hoverable:
	return get_parent_with_class( \
		search_start, Hoverable, "Hoverable") as Hoverable

func get_parent_mesh(search_start: Node) -> MeshInstance3D:
	return get_parent_with_class( \
		search_start, MeshInstance3D, "MeshInstance3D") as MeshInstance3D

func get_parent_ContainerBehavior(search_start: Node) -> ContainerBehavior:
	return get_parent_with_class( \
		search_start, ContainerBehavior, "ContainerBehavior") as ContainerBehavior

func get_parent_node_3d(search_start: Node) -> Node3D:
	return get_parent_with_class( \
		search_start, Node3D, "Node3D") as Node3D
