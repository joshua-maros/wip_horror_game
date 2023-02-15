extends TrainAction

class_name MoveDoorsAction

var speed: float
var timer: float

func _init(s: float):
	speed = s
	timer = 0.0

func _process(delta: float, train: Train):
	timer += delta * abs(speed)
	if speed < 0.0:
		train.set_door_openness(1.0 - train.door_anim_curve.sample(timer))
	else:
		train.set_door_openness(train.door_anim_curve.sample(timer))

func is_done() -> bool:
	return timer >= 1.0
