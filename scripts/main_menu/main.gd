extends Node2D

func _ready():
	#Utils.saveGame()
	#Utils.loadGame()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_node("UI/VSplitContainer/VBoxContainer/MarginContainer5/NewGame").grab_focus()

func _on_quit_pressed():
	get_tree().quit()


func _on_new_game_pressed():
	Game.deathBattle = false
	Game.hardMode = false
	Game.isLastStand = false
	Utils.reset_total_metrics()
	Utils.reset_single_metrics()
	Game.startScene = "res://scenes/areas/immortal.tscn"
	TransitionManager.fade_to_scene("immortal")
	#get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_play_pressed():
	#TransitionManager.fade_to_scene()
	if Game.startScene:
		Game.deathBattle = false
		Game.hardMode = false
		Game.isLastStand = false
		Utils.reset_single_metrics()
		get_tree().change_scene_to_file(Game.startScene)
	else:
		_on_new_game_pressed()


func _on_hard_mode_pressed():
	#TransitionManager.fade_to_scene()
	Game.deathBattle = false
	Game.hardMode = true
	Game.isLastStand = false
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")


func _on_death_battle_pressed():
	get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
	Game.deathBattle = true
	Game.hardMode = false
	Game.isLastStand = false
