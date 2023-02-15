extends TrainAction

class_name MoveAction

enum Direction {ARRIVE, DEPART}

var direction: Direction
var movement_timer: float
var _done = false
var parked_pos: Vector3

func _init(d: Direction, p: Vector3, t: float):
	direction = d
	parked_pos = p
	movement_timer = t

func start(train: Train):
	if direction == Direction.ARRIVE:
		train.decelerate_sound.play()
	elif direction == Direction.DEPART:
		train.accelerate_sound.play()

func _process(delta: float, train: Train):
	var multiplier: float
	if direction == Direction.ARRIVE:
		movement_timer -= delta
		_done = movement_timer <= 0.0
		multiplier = -1.0
	elif direction == Direction.DEPART:
		movement_timer += delta
		multiplier = 1.0
	if _done:
		train.position = parked_pos
	else:
		train.position = parked_pos + Vector3(0, 0, _compute_offset(train))

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
