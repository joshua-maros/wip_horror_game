extends Node

var transition_controller: LevelTransitionController = null

func emit_call_train():
	transition_controller.emit_level_event( \
		LevelTransitionController.LevelEvent.CALL_TRAIN)

func emit_objective_complete():
	transition_controller.emit_level_event( \
		LevelTransitionController.LevelEvent.OBJECTIVE_COMPLETE)
