extends TrainAction

class_name SetLightsAction

var amount: float

func _init(a: float):
	amount = a

func start(train: Train):
	train.set_door_light_brightness(amount)

func is_done() -> bool:
	return true
