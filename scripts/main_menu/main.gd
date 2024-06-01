extends Node2D

func _ready():
	#Utils.saveGame()
	#Utils.loadGame()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_quit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	Game.hardMode = false
	Utils.reset_total_metrics()
	Utils.reset_single_metrics()
	Game.startScene = "res://scenes/areas/immortal.tscn"
	TransitionManager.fade_to_scene("immortal")
	#get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_play_pressed():
	#TransitionManager.fade_to_scene()
	if Game.startScene:
		Game.hardMode = false
		Utils.reset_single_metrics()
		get_tree().change_scene_to_file(Game.startScene)
	else:
		_on_new_game_pressed()


func _on_hard_mode_pressed():
	#TransitionManager.fade_to_scene()
	Game.hardMode = true
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_death_battle_pressed():
	pass # Replace with function body.
