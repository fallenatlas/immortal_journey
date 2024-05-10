extends CharacterBody2D

@onready var speakingArea = $Area2D

@onready var normalSprite = $AnimatedSprite2D
@onready var shadowSprite = $Sprite2D

func _ready():
	Events.switch_world.connect(_on_switch_world)

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		set_collision_mask_value(3, true)
		speakingArea.set_collision_mask_value(3, true)
		normalSprite.visible = true
		shadowSprite.visible = false
	if (not normalWorld):
		set_collision_mask_value(3, false)
		speakingArea.set_collision_mask_value(3, false)
		normalSprite.visible = false
		shadowSprite.visible = true
