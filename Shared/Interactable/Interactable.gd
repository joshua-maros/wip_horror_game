extends Node3D

class_name Interactable

var behaviors: Array[Behavior] = []

signal hover_start(player: Player)
signal hover_stop(player: Player)
signal interact_start(player: Player)
signal interact_stop(player: Player)

func _ready():
	for child in self.get_children():
		if child is Behavior:
			behaviors.push_back(child as Behavior)

func start_hovering(player: Player):
	emit_signal("hover_start", player)

func stop_hovering(player: Player):
	emit_signal("hover_stop", player)

func start_interacting(player: Player):
	emit_signal("interact_start", player)

func stop_interacting(player: Player):
	emit_signal("interact_stop", player)
