extends TrainAction

class_name SetLightsAction

@export var on: bool

func start(train: Train):
	train.set_door_light_brightness(1.0 if on else 0.0)

func is_done() -> bool:
	return true
