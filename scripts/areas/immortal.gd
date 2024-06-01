extends Node2D

@onready var normalWorldNode = get_node("NormalWorld")
@onready var deathWorldNode = get_node("DeathWorld")
@onready var deathWorldAmbientSound = get_node("DeathWorld/AmbientSound")
var deathWorldAmbientSoundTime = 0
@onready var anim = get_node("Cutscene")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.playerDead = false
	Game.playerHP = 10
	Game.courage = 100.0
	Game.isInvulnerable = false
	Game.isImmortal = true
	Game.canChangeWorlds = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Events.cutscene_finished.connect(_cutscene_finished)
	Events.switch_world.connect(_on_switch_world)
	Events.courage_depleted.connect(_on_courage_depleted)
	Events.took_damage.connect(_on_player_damage)
	deathWorldAmbientSound.stop()
	
	
	get_node("Player/Player").position = Vector2(-50, 215)
	get_node("Player/Player").change_camera_limits(-175, -500, 1000000, 300)
	get_node("TutorialPopups").visible = true
	get_node("UI").visible = true

func _process(delta):
	if Input.is_action_just_pressed("swith_world") and not Game.playerDead and Game.canChangeWorlds:
		#still a bit bugy but overall well
		#thing about having some indication of how the other world is
		change_world()

func _on_end_body_entered(body):
	if body.name == "Player":
		#TransitionManager.fade_to_scene("world")
		#get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
		anim.play("Cutscene_1")

func _cutscene_finished():
	anim.play("Cutscene_2")

func enable_change_world():
	Game.canChangeWorlds = true

func change_world():
	var map : TileMap
	if Game.normalWorld:
		map = deathWorldNode.get_node("TileMap")
	else:
		map = normalWorldNode.get_node("TileMap")
	var local_position = map.to_local(get_node("Player/Player").position)
	var cell = map.local_to_map(local_position)
	if (map.get_cell_source_id(0, cell) == -1):
		if Game.normalWorld and Game.courage > 0:
			Game.normalWorld = false
		else:
			Game.normalWorld = true
		Events.switch_world.emit(Game.normalWorld)

func remove_immortality():
	Game.isImmortal = false

func _on_courage_depleted():
	if not Game.normalWorld:
		Game.normalWorld = true
		Events.switch_world.emit(Game.normalWorld)

#func _physics_process(delta):
#	if (!Game.normalWorld):
#		Game.courage -= 5
		
func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		deathWorldAmbientSoundTime = deathWorldAmbientSound.get_playback_position()
		deathWorldAmbientSound.stop()
		normalWorldNode.visible = true
		normalWorldNode.get_node("ParallaxBackground").visible = true
		deathWorldNode.visible = false
		deathWorldNode.get_node("DeathWorldBackground").visible = false
		#make normal world visible and collidable
	if (not normalWorld):
		deathWorldAmbientSound.play(deathWorldAmbientSoundTime)
		normalWorldNode.visible = false
		normalWorldNode.get_node("ParallaxBackground").visible = false
		deathWorldNode.visible = true
		deathWorldNode.get_node("DeathWorldBackground").visible = true
		
func _on_player_damage(enemy : bool):
	if (Game.playerHP < 5):
		AudioServer.set_bus_send(AudioServer.get_bus_index("AmbientSound"), "Master")

