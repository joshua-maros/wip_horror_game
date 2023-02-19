extends Node3D

class_name SeatGroup

@export var boarding_posn_node: Node3D
@export var aisle_posn_node: Node3D

var boarding_posn: Vector3
var aisle_posn: Vector3
var seat_posns: Array[Vector3]

func _ready():
	# Children get initialized before the parent so we are automatically in
	# parking position.
	boarding_posn = boarding_posn_node.global_position
	aisle_posn = aisle_posn_node.global_position
	for seat_posn_node in get_children():
		if seat_posn_node.name.begins_with("SeatPos"):
			assert(seat_posn_node is Node3D)
			seat_posns.push_back(seat_posn_node.global_position)

