extends Node

class_name LevelTransitionController

@export var player: Player
@export var train: Train
@export var train_spawn_point: Node3D
var train_can_leave := false

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
