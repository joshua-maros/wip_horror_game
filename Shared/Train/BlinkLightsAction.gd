extends TrainAction

class_name BlinkLightsAction

var duration := 1.5
var cycle_time := duration / 3.0
var timer = 0.0

func _process(delta: float, train: Train):
	timer += delta
	if timer >= duration:
		train.set_door_light_brightness(0.0)
	else:
		var phase = fmod(timer, cycle_time) / cycle_time
		train.set_door_light_brightness((1.0 - phase)**2.0)

func is_done() -> bool:
	return timer >= duration
