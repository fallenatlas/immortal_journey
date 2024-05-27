extends CanvasLayer

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var AMBIENT_SOUND_BUS_ID = AudioServer.get_bus_index("AmbientSound")
@onready var menu = %Menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		menu.visible = !menu.visible
		if menu.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.05)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < 0.05)


func _on_ambient_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AMBIENT_SOUND_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(AMBIENT_SOUND_BUS_ID, value < 0.05)
