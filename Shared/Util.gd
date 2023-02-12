extends Node

const Hoverable = preload("res://Shared/Interactables/Hoverable.gd")
const Slot = preload("res://Shared/Interactables/Slot.gd")

func enable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody3D:
			(child as StaticBody3D).collision_layer = 1

func disable_colliders(on_root: Node):
	for child in on_root.get_children():
		if child is StaticBody3D:
			(child as StaticBody3D).collision_layer = 0

func get_parent_with_class_impl(search_start: Node, clas) -> Node:
	if search_start == null:
		return null
	elif search_start is clas:
		return search_start
	else:
		return get_parent_with_class_impl(search_start.get_parent(), clas)
		
# Get parent with class, only used to implement other methods.
func get_parent_with_class(search_start: Node, clas, clas_name: String) -> Node:
	var result = get_parent_with_class_impl(search_start, clas)
	assert(result != null, str(search_start) + " does not have a " \
		+ clas_name + " as a parent.")
	return result

func get_parent_hoverable(search_start: Node) -> Hoverable:
	return get_parent_with_class( \
		search_start, Hoverable, "Hoverable") as Hoverable

func get_parent_mesh(search_start: Node) -> MeshInstance3D:
	return get_parent_with_class( \
		search_start, MeshInstance3D, "MeshInstance3D") as MeshInstance3D

func get_parent_slot(search_start: Node) -> Slot:
	return get_parent_with_class( \
		search_start, Slot, "Slot") as Slot

func get_parent_node_3d(search_start: Node) -> Node3D:
	return get_parent_with_class( \
		search_start, Node3D, "Node3D") as Node3D
