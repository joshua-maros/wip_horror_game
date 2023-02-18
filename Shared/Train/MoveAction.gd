extends TrainAction

class_name MoveAction

enum Direction {ARRIVE, DEPART}

@export var direction: Direction
@export var invert: bool
var movement_timer: float
var _done = false

func start(train: Train):
	if direction == Direction.ARRIVE:
		train.decelerate_sound.play()
		movement_timer = train.ACCELERATION_TIME
	elif direction == Direction.DEPART:
		train.accelerate_sound.play()
		movement_timer = 0.0

func _process(delta: float, train: Train):
	var multiplier := -1.0 if invert else 1.0
	if direction == Direction.ARRIVE:
		movement_timer -= delta
		_done = movement_timer <= 0.0
	elif direction == Direction.DEPART:
		movement_timer += delta
		if movement_timer > train.ACCELERATION_TIME:
			if train.npc_train:
				_done = true
			else:
				LevelLogic.transition_controller.advance_level = true
	if _done and direction == Direction.ARRIVE:
		train.position = train.parked_pos
	else:
		train.position = train.parked_pos \
			+ Vector3(0, 0, multiplier * _compute_offset(train))

func is_done() -> bool:
	return _done

func _position_after_accelerating_for(t: Train, time: float):
	return t.TOP_SPEED / 3.0 / (t.ACCELERATION_TIME ** 2) * time ** 3

func _compute_offset(t: Train, ):
	# Integrated form of assuming velocity = TOP_SPEED(time/ACCELERATION_TIME)**2.
	if movement_timer > t.ACCELERATION_TIME:
		return _position_after_accelerating_for(t, t.ACCELERATION_TIME) \
			+ t.TOP_SPEED * (movement_timer - t.ACCELERATION_TIME)
	else:
		return _position_after_accelerating_for(t, movement_timer)
