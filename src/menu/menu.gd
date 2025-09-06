extends Node2D

@onready var cloud_title: Sprite2D = $CanvasLayer/CloudTitle
@onready var menu: PanelContainer = $CanvasLayer/Menu
@onready var clouds: Node2D = $CanvasLayer/Clouds
@onready var buttons_container: VBoxContainer = %"VBoxContainer Buttons"


func _ready() -> void:
	for button: Button in buttons_container.get_children():
		button.text= " ".join(button.text.split())
	
	for cloud in clouds.get_children():
		#var new_tween:= create_tween()
		#new_tween.tween_property(cloud, "position:y", 10, 2.0).as_relative().set_ease(Tween.EASE_IN_OUT)
		#new_tween.tween_property(cloud, "position:y", -10, 2.0).as_relative().set_ease(Tween.EASE_IN_OUT)
		#new_tween.set_loops()
		cloud.set_meta("delta", randf() * 10)
		cloud.set_meta("orig_y", cloud.position.y)

	#set_process(false)
	cloud_title.show()

	#not working
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	var duration:= 1.5
	
	var tween:= create_tween()
	tween.tween_property(cloud_title, "position:y", 250, duration)
	tween.parallel()
	tween.tween_property(cloud_title, "scale", Vector2.ONE * 0.5, duration)
	tween.parallel()
	
	menu.modulate.a= 0
	tween.tween_property(menu, "modulate:a", 1.0, duration - 0.5).set_delay(0.5)
	tween.tween_callback(wiggle_clouds)


func wiggle_clouds():
	#var tween:= create_tween()
	#tween.tween_property(cloud_title, "position:y", 10, 2.0).as_relative().set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(cloud_title, "position:y", -10, 2.0).as_relative().set_ease(Tween.EASE_IN_OUT)
	#tween.set_loops()


	set_process(true)

func _process(delta: float) -> void:
	var freq:= 1.0
	var amp:= 30.0
	for cloud in clouds.get_children():
		cloud.position.y= sin(cloud.get_meta("delta") * freq) * amp + cloud.get_meta("orig_y")
		cloud.set_meta("delta", cloud.get_meta("delta") + delta)
