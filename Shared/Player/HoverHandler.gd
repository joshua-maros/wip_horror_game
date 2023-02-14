extends RefCounted

class_name HoverHandler

var _player: Player = null
var _prev_hovering: Interactable = null

func _init(p: Player):
	_player = p

func _process():
	var target = _player.target.interactable()
	if target != _prev_hovering:
		_stop_hovering_previous_object()
		_start_hovering(target)

func _stop_hovering_previous_object():
	if _prev_hovering != null:
		_call_stop_hovering(_prev_hovering)
	_prev_hovering = null

func _call_stop_hovering(target: Interactable):
	target.stop_hovering(_player)
	for child in target.glued_children:
		_call_stop_hovering(child)

func _start_hovering(target: Interactable):
	if target != null:
		_call_start_hovering(target)
	_prev_hovering = target

func _call_start_hovering(target: Interactable):
	target.start_hovering(_player)
	for child in target.glued_children:
		_call_start_hovering(child)
