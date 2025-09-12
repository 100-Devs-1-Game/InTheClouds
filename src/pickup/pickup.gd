class_name Pickup
extends Area2D

@onready var label: Label = $Label


var upgrade: Upgrade:
	set(u):
		assert(is_inside_tree())
		upgrade= u
		label.text= upgrade.text


func _on_body_entered(body: Node2D) -> void:
	assert(body is WindPlatformerMinigamePlayer)
	(body as WindPlatformerMinigamePlayer).pick_up(self)
