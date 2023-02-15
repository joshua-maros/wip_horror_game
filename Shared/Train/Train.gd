extends Node3D

class_name Train

@export var player_detector: Area3D
@export var accelerate_sound: AudioStreamPlayer3D
@export var decelerate_sound: AudioStreamPlayer3D
var actions: Array[TrainAction] = []

var last_player_pos = Vector3.ZERO
var time_player_not_moving = 0.0
var TOP_SPEED := 30.0
var ACCELERATION_TIME := 15.0

func _ready():
	var a = MoveAction.new(MoveAction.Direction.ARRIVE, position, 18.0)
	a.start(self)
	actions.push_back(a)
	a = MoveAction.new(MoveAction.Direction.DEPART, position, 0.0)
	actions.push_back(a)

#func is_player_on_board():
#	return $PlayerDetector.get_overlapping_bodies().size() > 0

#func get_player_on_board():
#	return $PlayerDetector.get_overlapping_bodies()[0]

func _process(delta):
	var start_pos = position.z
	actions[0]._process(delta, self)
	if actions[0].is_done():
		actions.pop_front()
		actions[0].start(self)
	var offset = position.z - start_pos
	var speed = abs(offset / delta)
	$DriveLoop.pitch_scale = speed / TOP_SPEED
