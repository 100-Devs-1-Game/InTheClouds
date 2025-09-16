class_name UI
extends CanvasLayer

@onready var label_time: Label = %"Label Time"
@onready var label_level_up: Label = %"Label Level Up"


func _process(delta: float) -> void:
	var secs: float= Global.elapsed_game_time
	label_time.text= Utils.get_time_string(secs)
	
	if label_level_up.visible:
		label_level_up.modulate.a-= delta
		if label_level_up.modulate.a <= 0:
			label_level_up.hide()


func show_level_up(upgrade: Upgrade):
	label_level_up.modulate.a= 1
	var text:= upgrade.text
	text= text.replace("\n", " ")
	label_level_up.text= "%s Level  %d / %d" % [ text, upgrade.level, upgrade.max_level ]
	label_level_up.show()
