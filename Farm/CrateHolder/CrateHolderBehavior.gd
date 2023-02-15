extends ContainerBehavior

@export var insertion_point: Node3D
var held_crate: Interactable

func can_take(holdable: HoldableBehavior):
	return holdable.label == "Crate"

func start_taking(holdable: HoldableBehavior):
	held_crate = holdable.parent
	parent.hover_start.connect(held_crate.start_hovering)
	parent.hover_stop.connect(held_crate.stop_hovering)
	parent.interact_start.connect(held_crate.start_interacting)
	parent.interact_stop.connect(held_crate.stop_interacting)

func start_removing(holdable: HoldableBehavior):
	parent.hover_start.disconnect(held_crate.start_hovering)
	parent.hover_stop.disconnect(held_crate.stop_hovering)
	parent.interact_start.disconnect(held_crate.start_interacting)
	parent.interact_stop.disconnect(held_crate.stop_interacting)
	held_crate = null

func get_insertion_point() -> Transform3D:
	return insertion_point.transform

func get_halfway_point() -> Transform3D:
	return insertion_point.transform.translated(Vector3(0, 0.2, 0))
