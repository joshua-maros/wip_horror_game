extends ProceduralAnimation

class_name HoldAnim

var destination: Node3D

func _init(d: Node3D):
	destination = d

func on_start():
	pass

func evaluate():
	target.global_transform = destination.global_transform
