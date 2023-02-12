extends RefCounted

const Interactable = preload("res://Shared/Interactables/Interactable.gd")
const Target = preload("Target.gd")

var last_interacted: Interactable = null
var captured = false
var interaction_requested = false
var crosshair_ray: RayCast3D = null

func _init(cr):
	crosshair_ray = cr

func request_interaction():
	interaction_requested = true

func stop_interacting():
	if last_interacted != null:
		last_interacted.on_interact_end()
		captured = false
		last_interacted = null

func physics_process(t: Target):
	if interaction_requested:
		interaction_requested = false
		if t.target_interactable() != null:
			start_interacting_with_object(t.target_interactable())

func start_interacting_with_object(obj: Interactable):
	obj.on_interact_start()
	captured = obj.captures_cursor() == true
	last_interacted = obj
