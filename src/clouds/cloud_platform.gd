class_name WindPlatformerMinigameCloudPlatform
extends AnimatableBody2D

@export var parts_scene: PackedScene

@onready var full_cloud: Sprite2D = $FullCloud
@onready var player_detection_area: Area2D = $"Player Detection Area"

var speed := randf_range(-50, 50)
var parts: Node2D



func _ready() -> void:
	modulate = modulate.darkened(randf_range(0.0, 0.25))
	if GameSettings.low_perf_mode:
		player_detection_area.queue_free()
		set_parts_areas_active(false)


func _physics_process(delta: float) -> void:
	position= calculate_cloud_position(position, speed, delta)

	if out_of_bounds(position, speed, get_viewport_rect()):
		queue_free()


func set_parts_areas_active(b: bool):
	if b:
		if not parts:
			parts= parts_scene.instantiate()
			add_child(parts)
			full_cloud.hide()
	else:
		if parts:
			parts.queue_free()
			parts= null
			full_cloud.show()


static func calculate_cloud_position(pos: Vector2, vel: float, delta: float):
	var drop_speed: float= sqrt(Global.elapsed_game_time)
	return pos + Vector2(vel * delta, drop_speed * delta)


static func out_of_bounds(pos: Vector2, vel: float, viewport: Rect2)-> bool:
	if vel < 0 and pos.x < -100 :
		return true
	elif vel > 0 and pos.x > viewport.size.x + 100:
		return true
	elif pos.y > viewport.size.y + 100:
		return true
	return false

func _on_player_detection_area_body_entered(_body: Node2D) -> void:
	set_parts_areas_active(true)


func _on_player_detection_area_body_exited(_body: Node2D) -> void:
	set_parts_areas_active(false)
