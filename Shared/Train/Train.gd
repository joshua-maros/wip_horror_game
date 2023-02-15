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
var actions: Array[TrainAction] = []
@onready var cars: Array[TrainCar] = [car1, car2, car3]

var last_player_pos = Vector3.ZERO
var time_player_not_moving = 0.0
var TOP_SPEED := 30.0
var ACCELERATION_TIME := 15.0

func _ready():
	var a = MoveAction.new(MoveAction.Direction.ARRIVE, position, 18.0)
	actions.push_back(a)
	actions.push_back(BlinkLightsAction.new())
	actions.push_back(SetLightsAction.new(1.0))
	actions.push_back(MoveDoorsAction.new(0.5))
	actions.push_back(WaitForPlayerAction.new(false))
	actions.push_back(BlinkLightsAction.new())
	actions.push_back(SetLightsAction.new(1.0))
	actions.push_back(MoveDoorsAction.new(-0.5))
	actions.push_back(SetLightsAction.new(0.0))
	actions.push_back(WaitForLevelCompletion.new())
	actions.push_back(BlinkLightsAction.new())
	actions.push_back(SetLightsAction.new(1.0))
	actions.push_back(MoveDoorsAction.new(0.5))
	actions.push_back(WaitForPlayerAction.new(true))
	actions.push_back(BlinkLightsAction.new())
	actions.push_back(SetLightsAction.new(0.0))
	actions.push_back(MoveDoorsAction.new(-0.5))
	a = MoveAction.new(MoveAction.Direction.DEPART, position, 0.0)
	actions.push_back(a)
	
	actions[0].start(self)
	
	# Store it outside the level so we don't start playing sound on game start.
	# Once the animations kick in, they will immediately override this.
	position = Vector3(0, 1000, 0)
	
	set_door_light_brightness(0.0)

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
		actions[0].start(self)
	var offset = position - start_pos
	var overlapping = player_detector.get_overlapping_bodies()
	if overlapping.size() > 0:
		var maybe_player = overlapping[0]
		if maybe_player is Player:
			maybe_player.move(offset)
	var speed = abs(offset.length() / delta)
	for car in cars:
		car.animate(speed, self)
	$DriveLoop.pitch_scale = max(speed / TOP_SPEED, 0.1)
	$DriveLoop.volume_db = min(3.0 * log(speed / TOP_SPEED), -5.0)
