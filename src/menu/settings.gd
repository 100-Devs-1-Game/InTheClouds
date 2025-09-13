class_name MenuSettings
extends PanelContainer

@onready var check_box_fullscreen: CheckBox = %"CheckBox Fullscreen"
@onready var slider_volume: HSlider = %"HSlider Volume"
@onready var check_box_low_performance: CheckBox = %"CheckBox2 Low Performance"



func open():
	check_box_fullscreen.button_pressed= GameSettings.fullscreen
	slider_volume.value= GameSettings.volume
	check_box_low_performance.button_pressed= GameSettings.low_perf_mode
	show()
	

func _on_check_box_fullscreen_toggled(toggled_on: bool) -> void:
	GameSettings.fullscreen= toggled_on


func _on_h_slider_volume_drag_ended(value_changed: bool) -> void:
	GameSettings.volume= slider_volume.value


func _on_check_box_2_low_performance_toggled(toggled_on: bool) -> void:
	GameSettings.low_perf_mode= toggled_on


func _on_button_back_pressed() -> void:
	hide()
