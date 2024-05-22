extends Area2D

@onready var sprite = $".."

func _ready():
	Events.switch_world.connect(_on_switch_world)

func _input(event):
	if event.is_action_pressed("interact") and len(get_overlapping_bodies()) > 0:
		rest()
		

func rest():
	TransitionManager.fade_to_scene(sprite.name)


func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		sprite.visible = true
		monitoring = true
	if (not normalWorld):
		sprite.visible = false
		monitoring = false


