extends Node2D

func _ready():
	#Utils.saveGame()
	#Utils.loadGame()
	pass

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	#TransitionManager.fade_to_scene()
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_hard_mode_pressed():
	#TransitionManager.fade_to_scene()
	Game.hardMode = true
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")
