extends "FiniteProceduralAnimation.gd"

const HoldAnim = preload("HoldAnim.gd")
const ContainerBehavior = preload("res://Shared/Interactables/ContainerBehavior.gd")

var start: Transform3D
var container: ContainerBehavior
var destination: Node3D
var halfway: Node3D
var cutoff: float = 0.7

func _init(s: ContainerBehavior):
	assert(s != null)
	container = s
	destination = container.get_insertion_point()
	halfway = container.get_halfway_point()

func on_start():
	start = target.transform

func evaluate():
	if halfway != null:
		var middle = halfway.global_transform
		if progress() < cutoff:
			target.transform = start.interpolate_with(
				middle, 
				progress() / cutoff
			)
		else:
			target.transform = middle.interpolate_with(
				destination.global_transform, 
				(progress() - cutoff) / (1.0 - cutoff)
			)
	else:
		target.transform = start.interpolate_with(
			destination.global_transform, 
			progress()
		)

func on_finish():
	target.get_parent().remove_child(target)
	destination.add_child(target)
	target.transform = Transform3D.IDENTITY
	container.on_insert_end()
	Util.enable_colliders(target)
