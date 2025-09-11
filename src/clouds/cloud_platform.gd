class_name WindPlatformerMinigameCloudPlatform
extends AnimatableBody2D

@export var parts_scene: PackedScene

@onready var full_cloud: Sprite2D = $FullCloud

var speed := randf_range(-50, 50)
var parts: Node2D



func _ready() -> void:
	modulate = modulate.darkened(randf_range(0.0, 0.25))


func _physics_process(delta: float) -> void:
	var drop_speed: float= sqrt(Global.elapsed_game_time)
	position += Vector2(speed * delta, drop_speed * delta)
	if speed < 0 and position.x < -100 :
		queue_free()
	elif speed > 0 and position.x > get_viewport_rect().size.x + 100:
		queue_free()
	elif position.y > get_viewport_rect().size.y + 100:
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
	

func _on_player_detection_area_body_entered(_body: Node2D) -> void:
	set_parts_areas_active(true)


func _on_player_detection_area_body_exited(_body: Node2D) -> void:
	set_parts_areas_active(false)
