extends "FiniteProceduralAnimation.gd"

const HoldAnim = preload("HoldAnim.gd")
const Slot = preload("res://Shared/Interactables/Slot.gd")

var start: Transform3D
var destination: Node3D
var halfway: Node3D
var cutoff: float = 0.5

func _init(s: Slot, d: Node3D):
	assert(s != null)
	halfway = s.get_halfway_point()
	assert(d != null)
	destination = d

func snappiness():
	return -1

func duration():
	return 0.4

func on_start():
	start = target.global_transform
	var root = target.get_tree().root
	target.get_parent().remove_child(target)
	root.add_child(target)

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
	return HoldAnim.new(destination)

