class_name UI
extends CanvasLayer

@onready var label_time: Label = %"Label Time"


func _process(delta: float) -> void:
	var secs: float= Global.elapsed_game_time
	label_time.text= Utils.get_time_string(secs)
