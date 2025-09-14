extends Node

const NUM_SCORES= 5
const SAVE_FILE= "user://highscores.json"
const SETTINGS_FILE= "user://settings.cfg"

var highscores: Array[float]



func _ready() -> void:
	load_settings()
	load_highscores()


func load_highscores():
	if not FileAccess.file_exists(SAVE_FILE):
		return
	
	var text:= FileAccess.get_file_as_string(SAVE_FILE)
	var scores= JSON.parse_string(text)
	if not scores:
		push_error("Scores are empty")
		return
	prints("Save game loaded", scores)
	if scores is not Array:
		push_error("Scores aren't an Array")
		return
	
	highscores.assign(scores)


func save_highscores():
	var file:= FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(highscores))
	file.close()


func post_highscore(secs: float):
	highscores.append(secs)
	highscores.sort()
	highscores.reverse()
	while highscores.size() > NUM_SCORES:
		highscores.pop_back()
	
	save_highscores()


func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)

	if err != OK:
		push_warning("Config file not found")
		return

	GameSettings.fullscreen = config.get_value("config", "fullscreen")
	GameSettings.volume = config.get_value("config", "volume")
	GameSettings.low_perf_mode = config.get_value("config", "low_perf")
	GameSettings.music = config.get_value("config", "music")



func save_settings():
	var config = ConfigFile.new()

	config.set_value("config", "fullscreen", GameSettings.fullscreen)
	config.set_value("config", "volume", GameSettings.volume)
	config.set_value("config", "low_perf", GameSettings.low_perf_mode)
	config.set_value("config", "music", GameSettings.music)

	config.save(SETTINGS_FILE)
	
	
