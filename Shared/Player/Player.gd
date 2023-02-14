extends Node3D

class_name Player

@export var camera: Camera3D
@export var held_parent: Node3D
@export var crosshair_ray: RayCast3D
@onready var hand_handler: HandHandler = HandHandler.new(self) # lol
var hover_handler: HoverHandler = HoverHandler.new(self)
@onready var input_handler: InputHandler = InputHandler.new(self)
var target: Target

# Called when the node enters the scene tree for the first time.
func _ready():
	hand_handler._ready()
	input_handler._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_target()
	input_handler._process(delta)
	hand_handler._process(delta)
	hover_handler._process()
	
func _input(event):
	input_handler._input(event)

func _update_target():
	var from = crosshair_ray
	from.force_raycast_update()
	target = Target.new(from.get_collider(), from.get_collision_point())
