extends FiniteProceduralAnimation

class_name InsertAnim

var start: Transform3D
var container: ContainerBehavior
var destination: Transform3D
var halfway: Transform3D
var cutoff: float = 0.7

func _init(s: ContainerBehavior):
	assert(s != null)
	container = s
	destination = container.get_insertion_point()
	halfway = container.get_halfway_point()

func on_start():
	var old_transform := target.global_transform
	target.get_parent().remove_child(target)
	container.parent.add_child(target)
	target.global_transform = old_transform
	start = target.transform

func evaluate():
	if halfway != null:
		var middle = halfway
		if progress() < cutoff:
			target.transform = start.interpolate_with(
				middle, 
				progress() / cutoff
			)
		else:
			target.transform = middle.interpolate_with(
				destination, 
				(progress() - cutoff) / (1.0 - cutoff)
			)
	else:
		target.transform = start.interpolate_with(destination, progress())

func on_finish():
	# container.on_insert_end()
	Util.enable_colliders(target)
