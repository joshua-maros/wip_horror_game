extends RefCounted

var player: Node3D
var camera: Node3D
var input_queue = []

func _init(p: Node3D, c: Node3D):
	player = p
	camera = c

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
	pass

func handle_interact_end():
	pass
