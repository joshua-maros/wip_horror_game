extends Node3D

const HandState = preload("HandState.gd")
const HoverState = preload("HoverState.gd")
const InputHandler = preload("InputHandler.gd")
const InteractState = preload("InteractState.gd")
const Target = preload("Target.gd")

@onready var camera: Camera3D = $Camera
var place_cursor = MeshInstance3D.new()
@onready var interact_state: InteractState = InteractState.new($Camera/CrosshairRay)
@onready var hand_state: HandState = \
	HandState.new($Camera/HeldParent, place_cursor)
@onready var hover_state: HoverState = HoverState.new(hand_state)
@onready var input_handler: InputHandler \
	= InputHandler.new(self, camera, hand_state, interact_state)

# Called when the node enters the scene tree for the first time.
func _ready():
	place_cursor.set_name("PlaceCursor")
	place_cursor.material_override = Constants.cursor_mat
	get_tree().root.get_child(0).call_deferred("add_child", place_cursor)
	input_handler.ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input_handler.process(delta)
	hand_state.process(delta)
	return
	
func _input(event):
	input_handler.input(event)

func _physics_process(_delta):
	var target = get_raycast_result()
	hover_state.physics_process(target)
	interact_state.physics_process(target)
	hand_state.physics_process(target)

func get_raycast_result() -> Target:
	var from = $Camera/CrosshairRay
	from.force_raycast_update()
	return Target.new(from.get_collider(), from.get_collision_point())
