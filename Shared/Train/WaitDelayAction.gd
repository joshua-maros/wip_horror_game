extends TrainAction

class_name WaitDelayAction

@export var wait_for: float

func _process(delta: float, train: Train):
	wait_for -= delta

func is_done() -> bool:
	return wait_for <= 0.0
