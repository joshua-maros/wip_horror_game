extends Node3D

var last_player_pos = Vector3.ZERO
var time_player_not_moving = 0.0
var activated = false
var completed_parking_in_station = false
var top_speed = 30.0
var acceleration_time = 15.0
var movement_timer = 18.0
var park_pos = Vector3.ZERO

func _ready():
	park_pos = position
	position.z -= 100.0

func is_player_on_board():
	return $PlayerDetector.get_overlapping_bodies().size() > 0

func get_player_on_board():
	return $PlayerDetector.get_overlapping_bodies()[0]

func position_after_accelerating_for(time):
	return top_speed / 3.0 / (acceleration_time ** 2) * time ** 3

func compute_offset():
	# Integrated form of assuming velocity = top_speed(time/acceleration_time)**2.
	if movement_timer > acceleration_time:
		return position_after_accelerating_for(acceleration_time) \
			+ top_speed * (movement_timer - acceleration_time)
	else:
		return position_after_accelerating_for(movement_timer)

func set_internal_light_brightness(brightness):
	pass

func _process(delta):
	var start_pos = position.z
	if not completed_parking_in_station:
		movement_timer -= delta
		if movement_timer >= 0.0:
			position.z = park_pos.z - compute_offset()
		else:
			position = park_pos
			completed_parking_in_station = true
	elif activated:
		movement_timer += delta
		position.z = park_pos.z + compute_offset()
	var offset = position.z - start_pos
	var speed = offset / delta
	$DriveLoop.pitch_scale = speed / top_speed
	if is_player_on_board():
		var p = get_player_on_board()
		if (p.position - last_player_pos).length() / delta < 0.1:
			time_player_not_moving += delta
		else:
			time_player_not_moving = 0.0
		last_player_pos = p.position
		if time_player_not_moving > 1.3 and not activated:
			activated = true
			$Accelerate.play()
		get_player_on_board().position.z += offset
