extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.playerHP <= 0:
		Game.playerHP = 10
		Game.courage = 0

