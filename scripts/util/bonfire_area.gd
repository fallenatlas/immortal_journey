extends Area2D


func _input(event):
	if event.is_action_pressed("interact") and len(get_overlapping_bodies()) > 0:
		rest()
		

func rest():
	Game.playerHP = Game.maxHP
	
