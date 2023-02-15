extends Node

class_name LevelTransitionController

@export var player: Player
@export var train: Train
@export var train_spawn_point: Node3D
var train_can_leave := false
var advance_level := false
@export_file("*scn") var next_level: String
@export var fade: Control
@onready var fade_internal: ColorRect = fade.get_child(0)
var fade_in = 0.0
var fade_out = 0.0
var fade_time = 1.5

# Let all the scripts start doing their thing.
var initial_setup_frames: int = 5

func _init():
	LevelLogic.transition_controller = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if initial_setup_frames > 0:
		initial_setup_frames -= 1
		if initial_setup_frames == 0:
			player.global_transform = train_spawn_point.global_transform
	elif fade_in < 1.0:
		fade_in += delta / fade_time
		fade_internal.color.a = max(1.0 - fade_in, 0.0)
	elif advance_level:
		if fade_out < 1.0:
			fade_out += delta / fade_time
			fade_internal.color.a = min(fade_out, 1.0)
		else:
			get_tree().change_scene_to_file(next_level)
