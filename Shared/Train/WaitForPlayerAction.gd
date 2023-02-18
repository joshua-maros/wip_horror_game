extends TrainAction

class_name WaitForPlayerAction

enum PlayerAction { BOARDS, LEAVES }

var MIN_WAIT_TIME := 1.5
var player_in_car_timer = 0.0
@export var trigger_when_player: PlayerAction

func _process(delta: float, train: Train):
	var player_in_car = \
		train.player_detector.get_overlapping_bodies().size() > 0
	if player_in_car == (trigger_when_player == PlayerAction.BOARDS):
		player_in_car_timer += delta
	else:
		player_in_car_timer = 0.0

func is_done() -> bool:
	return player_in_car_timer >= MIN_WAIT_TIME
