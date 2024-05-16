extends Area2D

@export var left_limit : int = -100000
@export var top_limit : int = -100000
@export var right_limit : int = 100000
@export var bottom_limit : int = 100000

@onready var player : CharacterBody2D = get_parent().get_node("Player").get_node("Player")

func _on_body_entered(body):
	player.change_camera_limits(left_limit, top_limit, right_limit, bottom_limit)
