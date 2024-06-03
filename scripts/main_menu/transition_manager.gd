extends CanvasLayer

var file = "res://Dialogues/Transition_Text/transition_text.json"
var json_as_text = FileAccess.get_file_as_string(file)
var text = JSON.parse_string(json_as_text)

@onready var colorRect = $ColorRect
@onready var anim = $AnimationPlayer
@onready var label = $VBoxContainer/Label
@onready var skipTimer = $SkipTimer

var scene_transition

func _input(event):
	if event.is_action_pressed("interact") and anim.current_animation == "Fade" \
	 and skipTimer.is_stopped() and Game.playerCanMove == false:
		change_scene()
		anim.play("RESET")


func fade_to_scene(sceneName : String):
	skipTimer.start()
	$AnimationPlayer.play("Fade")
	label.text = text[sceneName][0]
	scene_transition = sceneName
	Game.playerCanMove = false
	Game.canChangeWorlds = false
	
func change_scene():
	Events.cutscene_finished.emit()
	match scene_transition:
		"immortal":
			change_to_immortal_scene()
		"world":
			change_to_level1_scene()
		"credits":
			change_to_end_scene()
		"end":
			end_game()
		_:
			rest_bonfire()
	
func change_to_immortal_scene():
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")
	enable_actions()
	
func change_to_level1_scene():
	get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
	enable_actions()
	
func change_to_end_scene():
	get_tree().change_scene_to_file("res://scenes/areas/end.tscn")
	
func end_game():
	get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")

func rest_bonfire():
	Game.playerHP = Game.maxHP
	enable_actions()
	

func enable_actions():
	Game.playerCanMove = true
	Game.canChangeWorlds = true
	

