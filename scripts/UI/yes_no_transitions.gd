extends CanvasLayer

@onready var anim = $AnimationPlayer

@onready var text = $VBoxContainer/Text

@onready var leftButton = $HBoxContainer/MarginContainer/Yes
@onready var rightButton = $HBoxContainer/MarginContainer2/No

@onready var menu = %Menu
@onready var pause : Control = get_node("Pause_Options")

@export var player : CharacterBody2D

var animation = "FadeIn"

func _ready():
	Events.died_in_boss.connect(died_in_boss_fight)
	Events.final_choice.connect(is_final_choice)
	
func _process(delta):
	if animation == "FadeIn":
		text.text = "Do you give up?"
		leftButton.text = "Yes"
		rightButton.text = "No"
	elif animation == "Decision":
		text.text = "What do you wish?"
		leftButton.text = "Regain immortality"
		rightButton.text = "Remain mortal"
		
		
func _on_yes_pressed():
	if animation == "FadeIn":
		visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")
	elif animation == "Decision":
		#Regain immortality
		pass
	

func _on_no_pressed():
	if animation == "FadeIn":
		Game.playerHP = 1
		Game.courage = 100
		Game.playerDead = false
		player.anim.play("Idle")
		player.dying = false
		
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		visible = false
		
		Game.isLastStand = true
		Events.last_stand.emit()
	elif animation == "Decision":
		#stay mortal
		pass


func died_in_boss_fight():
	visible = true
	anim.play("FadeIn")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func is_final_choice():
	visible = true
	anim.play("Decision")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func animationIsFadeIn():
	animation = "FadeIn"
	
func animationDecision():
	animation = "Decision"
