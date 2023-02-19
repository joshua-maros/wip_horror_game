extends FiniteProceduralAnimation

class_name PickUpAnim

var start: Transform3D
var destination: Node3D

func _init(d: Node3D):
	destination = d

func duration():
	return 0.3

func on_start():
	start = target.global_transform

func evaluate():
	target.global_transform = \
		start.interpolate_with(destination.global_transform, progress())

func on_finish():
	return HoldAnim.new(destination)
