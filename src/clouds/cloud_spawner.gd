class_name WindPlatformerMinigameCloudSpawner
extends Node2D

class AbstractCloud:
	var position: Vector2
	var speed: float

	func _init(_position: Vector2, _speed: float):
		position= _position
		speed= _speed



@export var cloud_scene: PackedScene
@export var clouds_node: Node
@export var player: WindPlatformerMinigamePlayer
@export var max_clouds: int = 50
@export var cloud_velocity_range: Vector2 = Vector2(20, 150)

@export var offscreen_x:= Vector2i(-200, 2120)
@export var y_range:= 2000
@export var y_despawn_range:= 4000
@export var abstract_threshold_y:= 1500

@onready var timer: Timer = $Timer

var abstract_clouds: Array[AbstractCloud]



func _ready() -> void:
	var viewport := get_viewport_rect().size
	#var x_offset: int = 100


func start() -> void:
	for i in max_clouds:
		spawn_cloud(build_spawn_rect())
	timer.start()


func spawn_cloud(rect: Rect2i, force_direction: int = 0):
	var pos= Vector2i(randi_range(rect.position.x, rect.position.x + rect.size.x), randi_range(rect.position.y, rect.position.y + rect.size.y))

	var dir: int = force_direction
	if dir == 0:
		dir = [-1, 1].pick_random()
	var speed: float= randf_range(cloud_velocity_range.x, cloud_velocity_range.y) * dir
		
	if abs(pos.y - player.position.y) < abstract_threshold_y:
		var cloud: WindPlatformerMinigameCloudPlatform = cloud_scene.instantiate()
		cloud.position = pos
		cloud.speed = speed

		clouds_node.add_child(cloud)
	else:
		abstract_clouds.append(AbstractCloud.new(pos, speed))


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


func simulate_abstract_clouds(delta: float):
	var stopwatch:= PerformanceUtils.Stopwatch.new()
	var ctr:= 0
	for cloud in abstract_clouds.duplicate():
		cloud.position= WindPlatformerMinigameCloudPlatform.calculate_cloud_position(cloud.position, cloud.speed, delta)
		if WindPlatformerMinigameCloudPlatform.out_of_bounds(cloud.position, cloud.speed, get_viewport_rect()):
			abstract_clouds.erase(cloud)
		if ctr > 50:
			stopwatch.pause= true
			await get_tree().process_frame
			stopwatch.pause= false
	
	stopwatch.stop("Simulate abstract clouds")


func _on_timer_timeout() -> void:
	var stopwatch:= PerformanceUtils.Stopwatch.new()
	
	for abs_cloud in abstract_clouds.duplicate():
		if abs(player.position.y - abs_cloud.position.y) < abstract_threshold_y:
			var cloud: WindPlatformerMinigameCloudPlatform = cloud_scene.instantiate()
			cloud.position = abs_cloud.position
			cloud.speed = abs_cloud.speed
			clouds_node.add_child(cloud)
			abstract_clouds.erase(abs_cloud)

	await get_tree().process_frame

	for cloud: WindPlatformerMinigameCloudPlatform in clouds_node.get_children():
		if abs(player.position.y - cloud.position.y) > abstract_threshold_y + 100:
			abstract_clouds.append(AbstractCloud.new(cloud.position, cloud.speed))
			cloud.queue_free()
		
	if get_total_clouds() >= max_clouds:
		return

	var rect:= build_spawn_rect()
	var offset:= 50
	var wide_y:= 500

	#prints(player.position.y, rect)

	var dir:= 0
	if RngUtils.chance100(50):
		rect.size.x= offset
		dir= 1
	else:
		rect.position.x= rect.position.x + rect.size.x - offset
		rect.size.x= offset
		dir= -1

	while get_total_clouds() < max_clouds:
		spawn_cloud(rect, dir)

	stopwatch.stop("Spawn cloud performance")
	simulate_abstract_clouds.call_deferred(timer.wait_time)


func get_total_clouds()-> int:
	return clouds_node.get_child_count() + abstract_clouds.size()
