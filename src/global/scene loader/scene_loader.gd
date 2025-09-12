extends Node

@export var menu_scene: PackedScene
@export var game_scene: PackedScene



func enter_menu():
	if Global.elapsed_game_time > 0:
		SaveManager.post_highscore(Global.elapsed_game_time)
	get_tree().change_scene_to_packed(menu_scene)


func enter_game():
	get_tree().change_scene_to_packed(game_scene)
