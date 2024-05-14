extends Node2D

var audio_jump = preload("res://Audio/SFX/12_Player_Movement_SFX/30_Jump_03.wav")
var audio_attack = preload("res://Audio/SFX/12_Player_Movement_SFX/56_Attack_03.wav")
var audio_switch_world = preload("res://Audio/SFX/12_Player_Movement_SFX/88_Teleport_02.wav")
var audio_dash = preload("res://Audio/SFX/8_Atk_Magic_SFX/25_Wind_01.wav")
var audio_damage = preload("res://Audio/SFX/12_Player_Movement_SFX/61_Hit_03.wav")
var audio_death = preload("res://Audio/SFX/10_Battle_SFX/69_Enemy_death_01.wav")

var audio_node = null

func _ready():
	audio_node = get_node("AudioStreamPlayer")
	audio_node.finished.connect(destroy_self)
	audio_node.stop()

func play_sound(sound_name, position=null):

	if audio_jump == null or audio_attack == null or audio_switch_world == null:
		print ("Audio not set!")
		queue_free()
		return

	if sound_name == "Jump":
		audio_node.stream = audio_jump
	elif sound_name == "Attack":
		audio_node.stream = audio_attack
	elif sound_name == "Switch_world":
		audio_node.stream = audio_switch_world
	elif sound_name == "Dash":
		audio_node.stream = audio_dash
	elif sound_name == "Damage":
		audio_node.stream = audio_damage
	elif sound_name == "Death":
		audio_node.stream = audio_death
	else:
		print ("UNKNOWN STREAM")
		queue_free()
		return

	# If you are using an AudioStreamPlayer3D, then uncomment these lines to set the position.
	#if audio_node is AudioStreamPlayer3D:
	#    if position != null:
	#        audio_node.global_transform.origin = position

	audio_node.play()


func destroy_self():
	audio_node.stop()
	queue_free()
