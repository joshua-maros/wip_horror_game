extends Node3D

class_name Train

@export var player_detector: Area3D
@export var accelerate_sound: AudioStreamPlayer3D
@export var decelerate_sound: AudioStreamPlayer3D
@export var car1: TrainCar
@export var car2: TrainCar
@export var car3: TrainCar
@export var door_anim_curve: Curve
@export var noise: Noise
@export var actions: Array[TrainAction]
var next_actions: Array[TrainAction]
@export var npc_train: bool
@onready var cars: Array[TrainCar] = [car1, car2, car3]

var last_player_pos = Vector3.ZERO
var time_player_not_moving = 0.0
var parked_pos: Vector3
var TOP_SPEED := 30.0
var ACCELERATION_TIME := 15.0

func _ready():
	parked_pos = position
	# Store it outside the level so we don't start playing sound on game start.
	# Once the animations kick in, they will immediately override this.
	position = Vector3(0, 1000, 0)
	set_door_light_brightness(0.0)
	
	for index in range(actions.size()):
		actions[index] = actions[index].duplicate()
		next_actions.push_back(actions[index].duplicate())
	actions[0].start(self)

func set_door_light_brightness(b: float):
	for car in cars:
		car.set_door_light_brightness(b)

func set_inside_light_brightness(b: float):
	for car in cars:
		car.set_inside_light_brightness(b)

func set_door_openness(s: float):
	for car in cars:
		car.set_door_openness(s)

func _process(delta: float):
	var start_pos = position
	actions[0]._process(delta, self)
	while actions[0].is_done():
		actions.pop_front()
		if actions.size() == 0:
			for action in next_actions:
				actions.push_back(action.duplicate())
		actions[0].start(self)
	var offset = position - start_pos
	var overlapping = player_detector.get_overlapping_bodies()
	if overlapping.size() > 0:
		var maybe_player = overlapping[0]
		if maybe_player is Player:
			maybe_player.move_involuntary(offset)
	var speed = abs(offset.length() / delta)
	for car in cars:
		car.animate(speed, self)
	$DriveLoop.pitch_scale = max(speed / TOP_SPEED, 0.1)
	$DriveLoop.volume_db = min(3.0 * log(speed / TOP_SPEED), -5.0)
