extends RefCounted

const HandState = preload("HandState.gd")
const InteractState = preload("InteractState.gd")

var player: Node3D
var camera: Node3D
var hand_state: HandState
var interact_state: InteractState
var input_queue = []

func _init(p: Node3D, c: Node3D, h: HandState, i: InteractState):
	player = p
	camera = c
	hand_state = h
	interact_state = i

func ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func input(event):
	var speed = 0.005
	if event is InputEventMouseMotion:
		var dy = event.relative.y * speed
		var dx = event.relative.x * speed
		camera.rotation.y -= dx
		camera.rotation.x -= dy

func process(delta: float):
	var dx = Input.get_axis('nx', 'px')
	var dy = Input.get_axis('ny', 'py')
	var speed = 2.0 * delta
	var direction = Quaternion.from_euler(camera.rotation) * Vector3(dx, 0, -dy)
	direction *= Vector3(1, 0, 1)
	player.position += direction.normalized() * speed
	
	if Input.is_action_pressed("exit"):
		player.get_tree().quit()
	if Input.is_action_just_pressed("interact"):
		handle_interact_start()
	elif Input.is_action_just_released("interact"):
		handle_interact_end()

func handle_interact_start():
	if hand_state.is_holding_anything():
		hand_state.request_put_down()
	else:
		# An individual object will only respond to one of these. Interactable
		# and MovableBehavior are distinct sub-classes of Hoverable.
		interact_state.request_interaction()
		hand_state.request_pick_up()

func handle_interact_end():
	interact_state.stop_interacting()
