extends CanvasLayer

var file = "res://Dialogues/Transition_Text/transition_text.json"
var json_as_text = FileAccess.get_file_as_string(file)
var text = JSON.parse_string(json_as_text)

@onready var label = $VBoxContainer/Label

var scene_transition

func fade_to_scene(sceneName : String):
	$AnimationPlayer.play("Fade")
	label.text = text[sceneName][0]
	scene_transition = sceneName
	Game.playerCanMove = false
	Game.canChangeWorlds = false
	
func change_scene():
	match scene_transition:
		"immortal":
			change_to_immortal_scene()
		"world":
			change_to_level1_scene()
		"bonfire1":
			rest_bonfire_1()
			
	
func change_to_immortal_scene():
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")
	enable_actions()
	
func change_to_level1_scene():
	get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
	enable_actions()

func rest_bonfire_1():
	Game.playerHP = Game.maxHP
	enable_actions()
	

func enable_actions():
	Game.playerCanMove = true
	Game.canChangeWorlds = true
