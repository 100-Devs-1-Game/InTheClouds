extends Node

@export var menu_scene: PackedScene
@export var game_scene: PackedScene
@export var skip_to_game: bool= false



func _ready() -> void:
	if skip_to_game:
		enter_game()
	else:
		enter_menu()


func enter_menu():
	if Global.elapsed_game_time > 0:
		SaveManager.post_highscore(Global.elapsed_game_time)
	get_tree().change_scene_to_packed.call_deferred(menu_scene)


func enter_game():
	get_tree().change_scene_to_packed.call_deferred(game_scene)


func has_returned_from_game()-> bool:
	return Global.elapsed_game_time > 0
