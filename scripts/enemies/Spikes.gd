extends Node2D


func _on_player_detection_body_entered(body):
	Game.take_damage(1, true)
