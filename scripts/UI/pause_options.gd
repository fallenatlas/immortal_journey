extends Control

@onready var audio_menu = %Menu
@onready var buttons = get_node("Buttons")

func _on_main_menu_button_pressed():
	get_tree().paused = false
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
