class_name WindPlatformerMinigameCloudSpawner
extends Node2D

signal cloud_spawned(cloud: WindPlatformerMinigameCloudPlatform)

@export var cloud_scene: PackedScene
@export var clouds_node: Node
@export var player: WindPlatformerMinigamePlayer
@export var max_clouds: int = 50
@export var cloud_velocity_range: Vector2 = Vector2(20, 150)

@export var offscreen_x:= Vector2i(-200, 2120)
@export var y_range:= 2000
@export var y_despawn_range:= 4000

@onready var timer: Timer = $Timer


func _ready() -> void:
	var viewport := get_viewport_rect().size
	#var x_offset: int = 100


func start() -> void:
	for i in max_clouds:
		spawn_cloud(build_spawn_rect())
	timer.start()


func spawn_cloud(rect: Rect2i, force_direction: int = 0):
	var pos= Vector2i(randi_range(rect.position.x, rect.position.x + rect.size.x), randi_range(rect.position.y, rect.position.y + rect.size.y))
		
	var cloud: WindPlatformerMinigameCloudPlatform = cloud_scene.instantiate()
	cloud.position = pos
	var dir: int = force_direction
	if dir == 0:
		dir = [-1, 1].pick_random()

	cloud.speed = randf_range(cloud_velocity_range.x, cloud_velocity_range.y) * dir

	clouds_node.add_child(cloud)
	cloud_spawned.emit(cloud)


func build_spawn_rect()-> Rect2i:
	var rect:= Rect2i(Vector2(offscreen_x.x, get_viewport_rect().position.y - y_range / 2),\
	 Vector2(offscreen_x.y - offscreen_x.x, y_range))
	
	rect.position.y+= player.position.y
	
	var rect_max_y:= rect.position.y + rect.size.y
	if rect_max_y > get_viewport_rect().size.y:
		var delta:= rect_max_y - get_viewport_rect().size.y
		rect.position.y-= delta / 2
		rect.size.y-= delta / 2

	return rect


func _on_timer_timeout() -> void:
	for cloud: WindPlatformerMinigameCloudPlatform in clouds_node.get_children():
		if abs(player.position.y - cloud.position.y) > y_despawn_range:
			cloud.queue_free()
		
	if clouds_node.get_child_count() >= max_clouds:
		return

	var rect:= build_spawn_rect()
	var offset:= 50

	prints(player.position.y, rect)

	if RngUtils.chance100(50):
		rect.size.x= offset
		spawn_cloud(rect, 1)
	else:
		rect.position.x= rect.position.x + rect.size.x - offset
		rect.size.x= offset
		spawn_cloud(rect, -1)
