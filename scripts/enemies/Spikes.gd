extends Node2D


const DAMAGE_TICK = 1.0


var damageTime = 0.0
var isTouching = false


func _process(delta):
	if not isTouching:
		return
		
	damageTime += delta
	if damageTime >= DAMAGE_TICK:
		damageTime = 0.0
		Game.take_damage(1, true)


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		isTouching = true
		Game.take_damage(1, true)
		damageTime = 0.0


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		isTouching = false
