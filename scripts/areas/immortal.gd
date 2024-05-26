extends Node2D

@onready var normalWorldNode = get_node("NormalWorld")
@onready var deathWorldNode = get_node("DeathWorld")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.playerDead = false
	Game.playerHP = 10
	Game.courage = 100.0
	Game.isInvulnerable = false
	Game.isImmortal = true

func _process(delta):
	pass


func _on_end_body_entered(body):
	if body.name == "Player":
		#TransitionManager.fade_to_scene("world")
		get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
