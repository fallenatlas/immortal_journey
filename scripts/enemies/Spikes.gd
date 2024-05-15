extends Node2D


const DAMAGE_TICK = 1.0


var damageTime = 0.0
var isTouching = false


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		Game.inSpikes += 1


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		Game.inSpikes -= 1
