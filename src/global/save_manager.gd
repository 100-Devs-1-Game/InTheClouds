extends Node

const NUM_SCORES= 5
const SAVE_FILE= "user://highscores.json"

var highscores: Array[float]



func _ready() -> void:
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
