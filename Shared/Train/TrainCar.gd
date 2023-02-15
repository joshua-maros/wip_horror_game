extends Node3D

class_name TrainCar

@export var inside_light_mat: Material
@export var door_light_parent: Node3D
@export var inside_light_parent: Node3D
@export var left_door_1: Node3D
@export var left_door_2: Node3D
@export var left_door_3: Node3D
@export var right_door_1: Node3D
@export var right_door_2: Node3D
@export var right_door_3: Node3D

# We can't export this directly because of a bug.
var door_lights: Array[OmniLight3D] = []
var inside_lights: Array[OmniLight3D] = []
var left_doors: Array[Node3D] = [left_door_1, left_door_2, left_door_3]
var right_doors: Array[Node3D] = [right_door_1, right_door_2, right_door_3]

func _ready():
	for child in door_light_parent.get_children():
		if child is OmniLight3D:
			door_lights.push_back(child)
	for child in inside_light_parent.get_children():
		if child is OmniLight3D:
			inside_lights.push_back(child)

func set_inside_light_brightness(b: float):
	for light in inside_lights:
		light.light_energy = b * 0.4

func set_door_light_brightness(b: float):
	for light in door_lights:
		light.light_energy = b * 0.4
