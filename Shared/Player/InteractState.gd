extends RefCounted

const InteractableBehavior = \
	preload("res://Shared/Interactables/InteractableBehavior.gd")
const Target = preload("Target.gd")

var last_interacted: InteractableBehavior = null
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

func start_interacting_with_object(obj: InteractableBehavior):
	obj.on_interact_start()
	captured = obj.captures_cursor() == true
	last_interacted = obj
