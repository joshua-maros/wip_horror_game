extends AnimatableBody3D

class_name Player

@export var camera: Camera3D
@export var held_parent: Node3D
@export var crosshair_ray: RayCast3D
@onready var hand_handler: HandHandler = HandHandler.new(self) # lol
var hover_handler: HoverHandler = HoverHandler.new(self)
@onready var input_handler: InputHandler = InputHandler.new(self)
var target: Target
@onready var camera_default_pos = camera.position
var bob_phase = 0.0

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

func move(delta: Vector3):
	var start = position
	move_and_collide(delta)
	var actual_delta = position - start
	bob_phase += 6.0 * actual_delta.length()
	var y_bob = 0.05 * (1.0 -(0.5 + 0.5 * sin(bob_phase)) ** 2.0)
	var x_bob = 0.05 * cos(0.5 * bob_phase + PI / 4.0)
	camera.position = camera_default_pos + Vector3(x_bob, y_bob, 0)


func move_involuntary(delta: Vector3):
	move_and_collide(delta)

func _input(event):
	input_handler._input(event)

func _update_target():
	var from = crosshair_ray
	from.force_raycast_update()
	target = Target.new(from.get_collider(), from.get_collision_point())
