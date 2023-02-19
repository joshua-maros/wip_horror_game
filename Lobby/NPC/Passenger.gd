extends AnimatableBody3D

class_name Passenger

enum State {
	WAITING,
	MOVING,
}

@export var collider: CollisionShape3D
@export var waiting_for: Train
@export var seat_group_index: int
@export var seat_index: int
@onready var seat_group: SeatGroup = \
	waiting_for.cars[seat_group_index / 3].seat_groups[seat_group_index % 3]
@onready var collider_shape: CapsuleShape3D = collider.shape

var state_timer = 0.0
var state: State = State.WAITING
var look_angle: float
var move_targets: Array[Vector3] = []
var velocity: float
var MAX_VELOCITY := 1.3
var ACCELERATION := 2.0
var DECELERATION := 3.0

func _ready():
	look_angle = rotation.y
	enter_waiting()
	waiting_for.arrived.connect(on_train_arrived)
	waiting_for.doors_opened.connect(on_train_doors_open)

# A transition that is framerate-independent which starts fast and slows down.
func smooth_transition(from: float, to: float, delta: float) -> float:
	var dist: float = abs(from - to)
	var new_dist := exp(log(dist) - delta)
	if from < to:
		return to - new_dist
	else:
		return to + new_dist

func enter_waiting():
	state = State.WAITING
	look_angle = 0.5 * PI + 0.5 * randf_range(-1, 1) ** 3
	state_timer = randf_range(1, 3)

func enter_moving():
	state = State.MOVING
	velocity = 0.0

func on_train_arrived():
	move_targets.push_back(seat_group.boarding_posn)
	enter_moving()

func on_train_doors_open():
	move_targets.push_back(seat_group.aisle_posn)
	var s = seat_group.seat_posns[seat_index]
	move_targets.push_back(s)
	move_targets.push_back(s - Vector3(0, 0.4, 0))
	enter_moving()

func radius() -> float:
	return collider_shape.radius

func priority() -> float:
	if move_targets.size() == 0:
		return 0.0
	else:
		return -(move_targets[0] - position).length()

# The closest place the NPC would like to go that doesn't overlap with their
# current position. This is not usually their final destination, just a step
# they will take to get there.
func immediate_movement_position() -> Vector3:
	if move_targets.size() == 0:
		return position
	else:
		var delta := move_targets[0] - position
		var diameter := 2.0 * radius()
		if delta.length() < diameter:
			return position + delta
		else:
			return delta.normalized() * diameter + position

func _process(delta: float):
	state_timer -= delta
	if state == State.WAITING:
		var old_look_angle := rotation.y + PI * 2
		while abs(old_look_angle - look_angle) > PI:
			old_look_angle -= PI * 2
		rotation.y = smooth_transition(old_look_angle, look_angle, 10 * delta)
		if state_timer < 0.0:
			enter_waiting()
	elif state == State.MOVING:
		var dpos = (move_targets[0] - position)
		if dpos.length() > delta * velocity:
			dpos = dpos.normalized() * delta * velocity
			position += dpos
			var intersecting = false
			var me = immediate_movement_position()
			for npc in get_parent_node_3d().get_children():
				if npc == self:
					continue
				if npc is Passenger:
					var them = npc.immediate_movement_position()
					if (me - them).length() < 2.0 * radius() \
						and priority() < npc.priority():
						intersecting = true
						break
			if intersecting:
				velocity = max(velocity - delta * DECELERATION, 0.0)
			else:
				velocity = min(velocity + delta * ACCELERATION, MAX_VELOCITY)
		else:
			position += dpos
			move_targets.pop_front()
			if move_targets.size() == 0:
				enter_waiting()
		
