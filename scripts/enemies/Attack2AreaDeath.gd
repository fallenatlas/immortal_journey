extends Area2D

@onready var sprite = $"../Sprite2D"
@onready var coll = $CollisionShape2D

var normalAreaX

func _ready():
	monitoring = false
	normalAreaX = coll.position.x
	
func _process(delta):
	if sprite.flip_h == true:
		coll.position.x = - normalAreaX
	else:
		coll.position.x = normalAreaX
	
func _on_body_entered(body):
	if body.name == "Player":
		Game.take_damage(3, true)
