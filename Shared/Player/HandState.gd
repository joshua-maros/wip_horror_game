extends RefCounted

const ContainerBehavior = preload('res://Shared/Interactables/ContainerBehavior.gd')
const HandAnimationSystem = preload('HandAnimationSystem.gd')
const InsertAnim = preload('res://Shared/ProceduralAnimations/InsertAnim.gd')
const MovableBehavior = preload('res://Shared/Interactables/MovableBehavior.gd')
const PickUpAnim = preload('res://Shared/ProceduralAnimations/PickUpAnim.gd')
const PutDownAnim = preload('res://Shared/ProceduralAnimations/PutDownAnim.gd')
const RemoveAnim = preload('res://Shared/ProceduralAnimations/RemoveAnim.gd')
const Target = preload("Target.gd")

var camera: Node3D
var held_parent: Node3D
var place_cursor: MeshInstance3D
var holding: MovableBehavior
var pick_up_requested = false
var put_down_requested = false
var animations = HandAnimationSystem.new()

func _init(h: Node3D, c: MeshInstance3D):
	assert(h != null)
	camera = h.get_parent_node_3d()
	held_parent = h
	place_cursor = c

func request_pick_up():
	pick_up_requested = true

func request_put_down():
	put_down_requested = true

func is_holding_anything():
	return holding != null

func process(delta: float):
	animations.process(delta)

func physics_process(t: Target):
	if pick_up_requested:
		pick_up_requested = false
		if t.target_container() != null:
			remove_object_from_slot(t.target_container())
		elif t.target_movable() != null:
			print('movable')
			if t.target_movable().contained_in != null:
				remove_object_from_slot(t.target_movable().contained_in)
			else:
				print('pick up')
				pick_up_object(t.target_movable())
	var target_transform = object_place_transform(t)
	update_cursor(target_transform)
	if put_down_requested:
		put_down_requested = false
		put_down_object(target_transform, t.target_container())

func pick_up_object(obj: MovableBehavior):
	if obj != null:
		animations.start(PickUpAnim.new(held_parent), obj.get_parent())
		set_holding(obj)

func remove_object_from_slot(container: ContainerBehavior):
	var obj: MovableBehavior = container.contents
	if obj == null:
		return
	if not container.can_remove():
		return
	container.on_remove()
	obj.on_remove()
	animations.start(RemoveAnim.new(container, held_parent), obj.get_parent())
	set_holding(obj)
	
func set_holding(obj: MovableBehavior):
	obj.on_pick_up()
	holding = obj
	Util.disable_colliders(obj)

func object_place_transform(t: Target):
	if t.target_container() != null \
		and t.target_container().can_insert(holding.get_parent()):
		return t.target_container().get_insertion_point().global_transform
	elif t.collider != null:
		return Transform3D.IDENTITY.translated(t.position) \
			* Transform3D.IDENTITY.rotated(Vector3.UP, camera.rotation.y)
	else:
		return null

func update_cursor(target_transform):
	if holding == null or target_transform == null:
		place_cursor.hide()
	else:
		place_cursor.show()
		var mesh_obj = holding.get_node("Mesh")
		place_cursor.mesh = mesh_obj.mesh
		place_cursor.transform = target_transform * mesh_obj.transform

func put_down_object(target_transform: Transform3D, container: ContainerBehavior):
	assert(holding != null)
	if target_transform == null:
		return
	holding.on_put_down()
	var anim
	if container == null or not container.can_insert(holding.get_parent()):
		anim = PutDownAnim.new(target_transform)
		Util.enable_colliders(holding)
	else:
		holding.contained_in = container
		container.on_insert_start(holding.get_parent())
		anim = InsertAnim.new(container)
	animations.start(anim, holding.get_parent())
	holding = null
