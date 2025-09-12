class_name Upgrade
extends Resource

enum Effect { MOVE_SPEED, JUMP_HEIGHT, DOUBLE_JUMP, DIVE, AIR_CONTROL}

@export_multiline var text: String
@export var effect: Effect
@export var max_level: int

var level: int= 0


func can_spawn()-> bool:
	return level < max_level


func apply_effect(player: WindPlatformerMinigamePlayer):
	match effect:
		Effect.MOVE_SPEED:
			player.move_speed_factor= 1 + level / 10.0
		Effect.JUMP_HEIGHT:
			player.jump_speed_bonus= level * 10.0
		Effect.DOUBLE_JUMP:
			player.double_jump_factor= level / 10.0
		Effect.DIVE:
			player.dive_control= level / 10.0
		Effect.AIR_CONTROL:
			player.air_control_bonus= level / 10.0

			
