extends Node2D

@export var highscore_label_settings: LabelSettings

@onready var cloud_title: Sprite2D = %CloudTitle
@onready var menu: PanelContainer = $CanvasLayer/Menu
@onready var clouds: Node2D = %Clouds
@onready var buttons_container: VBoxContainer = %"VBoxContainer Buttons"
@onready var vbox_highscores: VBoxContainer = %"VBoxContainer Highscores"
@onready var settings: MenuSettings = $CanvasLayer/Settings


func _ready() -> void:
	for button: Button in buttons_container.get_children():
		button.text= " ".join(button.text.split())
	
	for cloud in clouds.get_children():
		cloud.set_meta("delta", randf() * 10)
		cloud.set_meta("orig_y", cloud.position.y)

	cloud_title.show()
	
	var duration:= 1.5
	if SceneLoader.has_returned_from_game():
		duration= 0.5
	
	var tween:= create_tween()
	tween.tween_property(cloud_title, "position:y", 250, duration)
	tween.parallel()
	tween.tween_property(cloud_title, "scale", Vector2.ONE * 0.5, duration)
	tween.parallel()
	
	menu.modulate.a= 0
	tween.tween_property(menu, "modulate:a", 1.0, duration - 0.5).set_delay(0.5)
	tween.tween_callback(wiggle_clouds)

	update_highscores()


func wiggle_clouds():
	set_process(true)


func _process(delta: float) -> void:
	var freq:= 1.0
	var amp:= 30.0
	for cloud in clouds.get_children():
		cloud.position.y= sin(cloud.get_meta("delta") * freq) * amp + cloud.get_meta("orig_y")
		cloud.set_meta("delta", cloud.get_meta("delta") + delta)


func update_highscores():
	while vbox_highscores.get_child_count() > 0:
		var child:= vbox_highscores.get_child(0)
		vbox_highscores.remove_child(child)
		child.queue_free()
	
	for i in SaveManager.NUM_SCORES:
		var label:= Label.new()
		var s:= ""
		if SaveManager.highscores.size() > i:
			s= Utils.get_time_string(SaveManager.highscores[i]) + "s"
		else:
			s= "---"

		label.label_settings= highscore_label_settings
		label.text= str(i + 1, ".  ", s)
		vbox_highscores.add_child(label)


func _on_button_play_pressed() -> void:
	SceneLoader.enter_game()


func _on_button_credits_pressed() -> void:
	pass # Replace with function body.


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_settings_pressed() -> void:
	settings.open()
