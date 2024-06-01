extends Control

@onready var audio_menu = %AudioMenu
@onready var upgrades_menu = %UpgradesMenu
@onready var buttons = get_node("Buttons")

func _on_main_menu_button_pressed():
	get_tree().paused = false
	Utils.update_metrics()
	get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")

func _on_audio_button_pressed():
	buttons.visible = false
	audio_menu.visible = true

func _on_audio_back_button_pressed():
	buttons.visible = true
	audio_menu.visible = false

func _on_hidden():
	audio_menu.visible = false
	buttons.visible = true

func _on_upgrades_button_pressed():
	buttons.visible = false
	upgrades_menu.visible = true
	
func _on_upgrades_back_button_pressed():
	buttons.visible = true
	upgrades_menu.visible = false

func _on_back_button_pressed():
	get_tree().paused = false
	visible = false
