extends Node3D

class_name TrainCar

@export var door_light_mat: StandardMaterial3D
@export var inside_light_mat: StandardMaterial3D
@export var door_light_parent: Node3D
@export var inside_light_parent: Node3D
@export var left_door_1: Node3D
@export var left_door_2: Node3D
@export var left_door_3: Node3D
@export var right_door_1: Node3D
@export var right_door_2: Node3D
@export var right_door_3: Node3D
@export var left_door_parent: Node3D
@export var right_door_parent: Node3D

# We can't export this directly because of a bug.
var door_lights: Array[OmniLight3D] = []
var inside_lights: Array[OmniLight3D] = []
@onready var left_doors: Array[Node3D] = [left_door_1, left_door_2, left_door_3]
@onready var right_doors: Array[Node3D] = [right_door_1, right_door_2, right_door_3]

func _ready():
	for child in door_light_parent.get_children():
		if child is OmniLight3D:
			door_lights.push_back(child)
	for child in inside_light_parent.get_children():
		if child is OmniLight3D:
			inside_lights.push_back(child)
	call_deferred("reparent_doors")

func reparent_doors():
	for door in left_doors:
		var old_transform = door.global_transform
		door.get_parent_node_3d().remove_child(door)
		left_door_parent.add_child(door)
		door.global_transform = old_transform
	for door in right_doors:
		var old_transform = door.global_transform
		door.get_parent_node_3d().remove_child(door)
		right_door_parent.add_child(door)
		door.global_transform = old_transform

func set_inside_light_brightness(b: float):
	for light in inside_lights:
		light.light_energy = b * 0.4
	inside_light_mat.emission_energy_multiplier = b

func set_door_light_brightness(b: float):
	for light in door_lights:
		light.light_energy = b * 0.2
	door_light_mat.emission_energy_multiplier = b

func set_door_openness(s: float):
	var d = 0.45 * s
	left_door_parent.position = Vector3(0, 0, d)
	right_door_parent.position = Vector3(0, 0, -d)
