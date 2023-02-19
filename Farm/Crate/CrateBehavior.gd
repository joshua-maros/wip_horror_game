extends ContainerBehavior

var num_carrots = 0
@export var positions: Node3D

func can_take(holdable: HoldableBehavior):
	return holdable.label == "Carrot"

func start_taking(holdable: HoldableBehavior):
	parent.glue_to_self(holdable.parent)
	num_carrots += 1
	if num_carrots == 9:
		LevelLogic.transition_controller.emit_level_event( \
			LevelTransitionController.LevelEvent.OBJECTIVE_COMPLETE)

func next_carrot_pos() -> Vector3:
	var pos: Node3D = positions.get_child(num_carrots)
	return pos.global_position - parent.global_position

func get_insertion_point() -> Transform3D:
	return Transform3D.IDENTITY.translated(next_carrot_pos())

func get_halfway_point() -> Transform3D:
	var pos := next_carrot_pos() + Vector3(0, 0.5, 0)
	return Transform3D.IDENTITY.translated(pos)
