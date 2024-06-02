extends CanvasLayer

@onready var anim = $AnimationPlayer

@onready var menu = %Menu
@onready var pause : Control = get_node("Pause_Options")

@export var player : CharacterBody2D

func _ready():
	Events.died_in_boss.connect(died_in_boss_fight)

func _on_yes_pressed():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")
	

func _on_no_pressed():
	
	Game.playerHP = 1
	Game.courage = 100
	Game.playerDead = false
	player.anim.play("Idle")
	player.dying = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	visible = false
	
	Game.isLastStand = true
	Events.last_stand.emit()


func died_in_boss_fight():
	visible = true
	anim.play("FadeIn")
	
	#pause.visible = !pause.visible
	#if pause.visible:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#get_tree().paused = !get_tree().paused
