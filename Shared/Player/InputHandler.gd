extends RefCounted

class_name InputHandler

var player: Player
var camera: Camera3D
var input_queue = []

signal interact_start
signal interact_end

func _init(p: Player):
	player = p
	camera = player.camera

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent):
	var speed = 0.005
	if event is InputEventMouseMotion:
		var dy = event.relative.y * speed
		var dx = event.relative.x * speed
		camera.rotation.y -= dx
		camera.rotation.x -= dy

func _process(delta: float):
	var dx = Input.get_axis('nx', 'px')
	var dy = Input.get_axis('ny', 'py')
	var speed = 2.0 * delta
	var direction = Quaternion.from_euler(camera.rotation) * Vector3(dx, 0, -dy)
	direction *= Vector3(1, 0, 1)
	player.move(direction.normalized() * speed)
	
	if Input.is_action_pressed("exit"):
		player.get_tree().quit()
	if Input.is_action_just_pressed("interact"):
		_handle_interact_start()
	elif Input.is_action_just_released("interact"):
		_handle_interact_end()

func _handle_interact_start():
	player.hand_handler.start_interacting()
		
func _handle_interact_end():
	player.hand_handler.stop_interacting()
