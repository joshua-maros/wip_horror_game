extends Node

const ContainerBehavior = preload("ContainerBehavior.gd")

signal picked_up()
signal put_down()
signal inserted(container)
signal removed(container)

var contained_in: ContainerBehavior

func on_pick_up():
	emit_signal("picked_up")

func on_put_down():
	emit_signal("put_down")

func on_insert_start(container: ContainerBehavior):
	contained_in = container
	emit_signal("inserted", container)

func on_insert_end():
	pass

func on_remove():
	emit_signal("removed", contained_in)
	contained_in = null
