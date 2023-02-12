extends RefCounted

const Hoverable = preload("res://Shared/Interactables/Hoverable.gd")
const Interactable = preload("res://Shared/Interactables/Interactable.gd")
const Movable = preload("res://Shared/Interactables/Movable.gd")
const Slot = preload("res://Shared/Interactables/Slot.gd")

var collider: StaticBody3D
var position: Vector3
var target: Hoverable = null

func _init(c: StaticBody3D, p: Vector3):
	collider = c
	position = p
	if collider == null:
		return
	var candidate = collider
	while candidate != null and not candidate is Hoverable:
		candidate = candidate.get_parent_spatial()
	target = candidate

func target_movable() -> Movable:
	if target is Movable:
		return target as Movable
	else:
		return null

func target_interactable() -> Interactable:
	if target is Interactable:
		return target as Interactable
	else:
		return null

func target_slot() -> Slot:
	if target is Slot:
		return target as Slot
	else:
		return null
