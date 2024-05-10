extends Area2D

func _ready():
	monitoring = false
	
func _on_body_entered(body):
	if body.name == "Player":
		Game.take_damage(3)
