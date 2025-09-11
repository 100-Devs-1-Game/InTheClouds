class_name WindPlatformerMinigameCloudPlatform
extends AnimatableBody2D

var speed := randf_range(-50, 50)

@onready var parts: Node2D = $Parts
@onready var full_cloud: Sprite2D = $FullCloud


func _ready() -> void:
	modulate = modulate.darkened(randf_range(0.0, 0.25))


func _physics_process(delta: float) -> void:
	position += Vector2(speed * delta, Global.elapsed_game_time * delta)
	if speed < 0 and position.x < -100 :
		queue_free()
	elif speed > 0 and position.x > get_viewport_rect().size.x + 100:
		queue_free()
	elif position.y > get_viewport_rect().size.y + 100:
		queue_free()


func set_parts_areas_active(b: bool):
	if not parts:
		return
	
	for part: WindPlatformerMinigameCloudPart in parts.get_children():
		part.active = b


func _on_player_detection_area_body_entered(_body: Node2D) -> void:
	set_parts_areas_active(true)


func _on_player_detection_area_body_exited(_body: Node2D) -> void:
	set_parts_areas_active(false)
