extends TrainAction

class_name WaitForLevelCompletion

func is_done() -> bool:
	return LevelLogic.transition_controller.train_can_leave
