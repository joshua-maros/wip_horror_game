extends Node3D

@onready var camera: Camera3D = $Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dx = Input.get_axis('nx', 'px')
	var dy = Input.get_axis('ny', 'py')
	var speed = 2.0 * delta
	var direction = Quaternion.from_euler(camera.rotation) * Vector3(dx, 0, -dy)
	direction *= Vector3(1, 0, 1)
	position += direction.normalized() * speed
	
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	
func _input(event):
	var speed = 0.005
	if event is InputEventMouseMotion and camera != null:
		var dy = event.relative.y * speed
		var dx = event.relative.x * speed
		camera.rotation.y -= dx
		camera.rotation.x -= dy
