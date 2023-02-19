extends RefCounted

class_name InputHandler

var player: Player
var camera: Camera3D
var input_queue = []
# So that we don't jump right back in to dialogue after finishing it.
var click_debounce: float

signal interact_start
signal interact_end

func _init(p: Player):
	player = p
	camera = player.camera

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	DialogueManager.dialogue_finished.connect(end_dialogue)

func _input(event: InputEvent):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	var speed = 0.005
	if event is InputEventMouseMotion:
		var dy = event.relative.y * speed
		var dx = event.relative.x * speed
		camera.rotation.y -= dx
		camera.rotation.x -= dy

func _process(delta: float):
	click_debounce -= min(delta, 0.05)
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	var dx = Input.get_axis('nx', 'px')
	var dy = Input.get_axis('ny', 'py')
	var speed = 2.0 * delta
	var direction = Quaternion.from_euler(camera.rotation) * Vector3(dx, 0, -dy)
	direction *= Vector3(1, 0, 1)
	player.move(direction.normalized() * speed)
	
	if Input.is_action_pressed("exit"):
		player.get_tree().quit()
	if Input.is_action_just_pressed("interact") and click_debounce <= 0.0:
		_handle_interact_start()
	elif Input.is_action_just_released("interact"):
		_handle_interact_end()

func start_dialogue(d: DialogueResource):
	DialogueManager.show_example_dialogue_balloon(d)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func end_dialogue():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	click_debounce = 0.2

func _handle_interact_start():
	var target := player.crosshair_ray.get_collider()
	if target != null:
		var npc = Util.get_parent_interactable_npc(target)
		if npc != null and npc.dialogue != null:
			start_dialogue(npc.dialogue)
			return
	player.hand_handler.start_interacting()
		
func _handle_interact_end():
	player.hand_handler.stop_interacting()
