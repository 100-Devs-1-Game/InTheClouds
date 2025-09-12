class_name PickupSpawner
extends Node2D

@export var pickup_scene: PackedScene
@export var upgrade_pool: Array[Upgrade]
@export var max_simultaneous: int= 3

@onready var pickups_node: Node2D = $Pickups



func _ready():
	for upgrade in upgrade_pool:
		upgrade.level= 0

	for i in max_simultaneous:
		spawn()


func spawn():
	if pickups_node.get_child_count() == max_simultaneous:
		var child= pickups_node.get_child(0)
		pickups_node.remove_child(child)
		child.queue_free()
	
	var spawned_dict: Dictionary
	for pickup: Pickup in pickups_node.get_children():
		if not spawned_dict.has(pickup.upgrade):
			spawned_dict[pickup.upgrade]= 0
		spawned_dict[pickup.upgrade]+= 1
	
	var arr:= upgrade_pool.duplicate()
	arr.shuffle()
	for upgrade: Upgrade in arr:
		if upgrade.can_spawn(spawned_dict):
			var pickup: Pickup= pickup_scene.instantiate()
			pickup.position= get_rand_pos()
			pickups_node.add_child(pickup)
			pickup.upgrade= upgrade
			return


func get_rand_pos()-> Vector2:
	var rect:= get_viewport_rect()
	var x_offset:= 50
	rect.position.x+= x_offset
	rect.size.x-= x_offset * 2
	
	var comp_x:= randf_range(rect.position.x, rect.position.x + rect.size.x)
	var comp_y:= randf_range(rect.position.y, rect.position.y + rect.size.y)
	var comp_y2:= randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	if RngUtils.chance100(50):
		comp_y= min(comp_y, comp_y2)

	comp_y+= get_viewport().get_camera_2d().position.y - get_viewport_rect().size.y / 2

	return Vector2(comp_x, comp_y)
