extends Area2D

@onready var nodeName = $".."


func _input(event):
	if event.is_action_pressed("interact") and len(get_overlapping_bodies()) > 0:
		rest()
		

func rest():
	TransitionManager.fade_to_scene(nodeName.name)
