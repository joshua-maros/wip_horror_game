extends "FiniteProceduralAnimation.gd"

var start: Transform3D
var destination: Transform3D

func _init(d: Transform3D):
	destination = d

func on_start():
	start = target.transform

func evaluate():
	target.transform = start.interpolate_with(destination, progress())

func on_finish():
	Util.enable_colliders(target)
