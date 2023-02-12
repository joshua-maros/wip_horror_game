extends "ProceduralAnimation.gd"

var destination: Node3D

func _init(d: Node3D):
	destination = d

func on_start():
	pass

func evaluate():
	target.transform = destination.global_transform
