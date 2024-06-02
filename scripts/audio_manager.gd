extends Node2D

@onready var fade = get_node("Fade")

var transition_time : float = 2
@onready var music0 = preload("res://Audio/SFX/ImMortal Jouney SFX Pack 3/Forest Ambience.wav")
@onready var music1 = preload("res://Audio/Music/Ambient1.mp3")
@onready var music2 = preload("res://Audio/SFX/ImMortal Jouney SFX Pack 3/Forest Ambience.wav")
@onready var music3 = preload("res://Audio/Music/Ambient1.mp3")
@onready var music4 = preload("res://Audio/SFX/ImMortal Jouney SFX Pack 3/Cave Ambience (Drips).wav")
@onready var music5 = preload("res://Audio/Music/Ambient1.mp3")
@onready var music6 = preload("res://Audio/SFX/ImMortal Jouney SFX Pack 3/Forest Ambience.wav")
@onready var music7 = preload("res://Audio/Music/BossFight.mp3")
@onready var ambient_player = $AmbientSound
@onready var music_player = $Music
@onready var player_1
@onready var player_2
@onready var music_playlist : Array = [music0, music1, music2, music3, music4, music5, music6, music7]
@onready var current_sound = 0
@onready var fadeType

	
func _ready():
	Events.music_transition.connect(transition)
	#SignalBus.emit_signal("music_transition",SignalBus.playlist[0]) # Test
	

func transition(next_sound : int):

	if current_sound == next_sound:
		return
	else:
		current_sound = next_sound
		if (next_sound % 2 == 0):
			player_1 = music_player
			player_2 = ambient_player
			fadeType = "FadeOut"
		else:
			player_1 = ambient_player
			player_2 = music_player
			fadeType = "FadeIn"
			player_1.stop()
		
		player_2.stream = music_playlist[next_sound]
		player_2.play()
		fade.play(fadeType)
