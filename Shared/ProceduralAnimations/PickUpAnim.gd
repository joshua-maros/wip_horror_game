extends "FiniteProceduralAnimation.gd"

const HoldAnim = preload("HoldAnim.gd")

var start: Transform3D
var destination: Node3D

func _init(d: Node3D):
	destination = d

func duration():
	return 0.3

func on_start():
	start = target.transform

func evaluate():
	target.transform = \
		start.interpolate_with(destination.global_transform, progress())

func on_finish():
	return HoldAnim.new(destination)
