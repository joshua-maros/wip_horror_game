extends FiniteProceduralAnimation

class_name PutDownAnim

var start: Transform3D
var destination: Transform3D

func _init(d: Transform3D):
	destination = d

func duration():
	return 0.3

func on_start():
	start = target.global_transform

func evaluate():
	target.global_transform = start.interpolate_with(destination, progress())

func on_finish():
	Util.enable_colliders(target)
