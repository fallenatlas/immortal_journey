extends Node2D

func _ready():
	#Utils.saveGame()
	#Utils.loadGame()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_quit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	Game.hardMode = false
	Game.startScene = "res://scenes/areas/immortal.tscn"
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_play_pressed():
	#TransitionManager.fade_to_scene()
	Game.hardMode = false
	if Game.startScene:
		get_tree().change_scene_to_file(Game.startScene)
	else:
		get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_hard_mode_pressed():
	#TransitionManager.fade_to_scene()
	Game.hardMode = true
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_death_battle_pressed():
	pass # Replace with function body.
