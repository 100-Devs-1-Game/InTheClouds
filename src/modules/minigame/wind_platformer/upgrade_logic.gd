class_name WindPlatformerMinigameUpgradeLogic
extends BaseMinigameUpgradeLogic

enum Type {
	MOVE_SPEED,
	AIR_CONTROL,
	DIVE,
	JUMP_HEIGHT,
	MORE_CLOUDS,
	BONUS2X,
	BONUS5X,
	DOUBLE_JUMP,
	BORDERS,
	COUNTDOWN,
	BURNING_FEET
}

@export var type: Type


func _apply_effect(game: BaseMinigame, upgrade: MinigameUpgrade):
	var my_game: WindPlatformerMinigame = game

	prints(upgrade.name, upgrade.get_current_effect_modifier())

	match type:
		Type.MOVE_SPEED:
			my_game.player.move_speed_factor = 1 + upgrade.get_current_effect_modifier()
		Type.AIR_CONTROL:
			my_game.player.air_control_bonus = upgrade.get_current_effect_modifier()
		Type.DIVE:
			my_game.player.dive_control = upgrade.get_current_effect_modifier()
		Type.JUMP_HEIGHT:
			my_game.player.jump_speed_bonus = upgrade.get_current_effect_modifier()
		Type.MORE_CLOUDS:
			my_game.cloud_spawner.cloud_bonus = int(upgrade.get_current_effect_modifier())
		Type.BONUS2X:
			my_game.cloud_spawner.multiplier_2x_chance = upgrade.get_current_effect_modifier()
		Type.BONUS5X:
			my_game.cloud_spawner.multiplier_5x_chance = upgrade.get_current_effect_modifier()
		Type.COUNTDOWN:
			my_game.countdown_bonus = int(upgrade.get_current_effect_modifier())
		Type.DOUBLE_JUMP:
			my_game.player.double_jump_factor = upgrade.get_current_effect_modifier()
		Type.BORDERS:
			my_game.activate_borders()
		Type.BURNING_FEET:
			my_game.player.burning_feet_duration = upgrade.get_current_effect_modifier()
