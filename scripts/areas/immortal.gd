extends Node2D

@onready var normalWorldNode = get_node("NormalWorld")
@onready var deathWorldNode = get_node("DeathWorld")
@onready var anim = get_node("Cutscene")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.playerDead = false
	Game.playerHP = 10
	Game.courage = 100.0
	Game.isInvulnerable = false
	Game.isImmortal = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Events.cutscene_finished.connect(_cutscene_finished)
	
	get_node("Player/Player").position = Vector2(101, 215)
	get_node("TutorialPopups").visible = true
	get_node("UI").visible = true

func _process(delta):
	pass


func _on_end_body_entered(body):
	if body.name == "Player":
		#TransitionManager.fade_to_scene("world")
		#get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
		anim.play("Cutscene_1")

func _cutscene_finished():
	anim.play("Cutscene_2")

func remove_immortality():
	Game.isImmortal = false
