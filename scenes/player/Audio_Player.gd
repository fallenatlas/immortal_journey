extends Node2D

var audio_jump = preload("res://Audio/SFX/ImMortal Jouney SFX Pack 3/Jump 3.wav")
var audio_attack1 = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Attack 2 V3 -15dB.wav")
var audio_attack2 = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Attack Swing 2 -15dB.wav")
var audio_switch_world = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Switch Worlds 2.wav")
var audio_dash = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Dash 1.wav")
var audio_damage = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Player Damage 2.wav")
var audio_death = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Player Death 1.wav")
var audio_upgrade = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Collect Flower 4 -20dB.wav")
var audio_courage_loss = preload("res://Audio/SFX/ImMortal Journey SFX Pack 2/Courage Loss 3.wav")
var audio_dash_fail = preload("res://Audio/SFX/10_UI_Menu_SFX/033_Denied_03.wav")

var audio_node = null

func _ready():
	audio_node = get_node("AudioStreamPlayer")
	audio_node.finished.connect(destroy_self)
	audio_node.stop()

func play_sound(sound_name, position=null):

	if audio_jump == null or audio_attack1 == null or audio_switch_world == null:
		print ("Audio not set!")
		queue_free()
		return

	if sound_name == "Jump":
		audio_node.stream = audio_jump
	elif sound_name == "Attack1":
		audio_node.stream = audio_attack1
	elif sound_name == "Attack2":
		audio_node.stream = audio_attack2
	elif sound_name == "Switch_world":
		audio_node.stream = audio_switch_world
	elif sound_name == "Dash":
		audio_node.stream = audio_dash
	elif sound_name == "Damage":
		audio_node.stream = audio_damage
	elif sound_name == "Death":
		audio_node.stream = audio_death
	elif sound_name == "Upgrade":
		audio_node.stream = audio_upgrade
	elif sound_name == "CourageLoss":
		audio_node.stream = audio_courage_loss
	elif sound_name == "DashFail":
		audio_node.stream = audio_dash_fail
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
