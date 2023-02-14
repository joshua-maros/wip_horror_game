extends Behavior

class_name ContainerBehavior

func _ready():
	super._ready()

func can_take(_holdable: HoldableBehavior):
	return true

func get_insertion_point() -> Transform3D:
	return Transform3D.IDENTITY.translated(Vector3(0, 0.0, 0))

func get_halfway_point() -> Transform3D:
	return Transform3D.IDENTITY.translated(Vector3(0, 1.0, 0))
