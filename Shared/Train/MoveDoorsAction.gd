extends TrainAction

class_name MoveDoorsAction

enum DoorDirection {
	OPEN,
	CLOSE
}

@export var direction: DoorDirection
var timer: float

func _process(delta: float, train: Train):
	timer += delta * 0.5
	if direction == DoorDirection.CLOSE:
		train.set_door_openness(1.0 - train.door_anim_curve.sample(timer))
	else:
		train.set_door_openness(train.door_anim_curve.sample(timer))

func finish(train: Train):
	if direction == DoorDirection.OPEN:
		train.doors_opened.emit()

func is_done() -> bool:
	return timer >= 1.0
