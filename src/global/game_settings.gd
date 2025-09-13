extends Node

var fullscreen: bool= false:
	set(f):
		fullscreen= f
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if f else DisplayServer.WINDOW_MODE_WINDOWED)

var volume: float= 0.5:
	set(v):
		volume= v
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), v)

var low_perf_mode: bool= false
