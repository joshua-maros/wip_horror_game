extends TrainAction

class_name WaitForLevelEvent

@export var trigger_on: LevelTransitionController.LevelEvent
var done = false

func start(train: Train):
	LevelLogic.transition_controller.level_event.connect(on_event)

func on_event(event: LevelTransitionController.LevelEvent):
	done = done or event == trigger_on

func is_done() -> bool:
	return done
