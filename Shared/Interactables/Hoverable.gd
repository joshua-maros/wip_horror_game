extends Node3D

signal hover_started()
signal hover_ended()

var hovered = false

func on_hover_start():
	var n: Node
	hovered = true
	emit_signal("hover_started")

func on_hover_end():
	hovered = false
	emit_signal("hover_ended")
