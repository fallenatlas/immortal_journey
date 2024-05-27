extends Node2D

@onready var normalWorldNode = get_node("NormalWorld")
@onready var deathWorldNode = get_node("DeathWorld")
@onready var normalWorldAmbientSound = get_node("NormalWorld/AmbientSound")
@onready var deathWorldAmbientSound = get_node("DeathWorld/AmbientSound")
var deathWorldAmbientSoundTime = 0
var normalWorldAmbientSoundTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.playerDead = false
	
	if Game.hardMode:
		Game.playerHP = 1
		Game.maxHP = 1
	else:
		Game.playerHP = 10
		
	Game.courage = 50.0
	Game.isInvulnerable = false
	Game.isImmortal = false
	Events.switch_world.connect(_on_switch_world)
	Events.courage_depleted.connect(_on_courage_depleted)
	Events.took_damage.connect(_on_player_damage)
	deathWorldAmbientSound.stop()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if Input.is_action_just_pressed("swith_world") and not Game.playerDead and Game.canChangeWorlds:
		#still a bit bugy but overall well
		#thing about having some indication of how the other world is
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
		normalWorldAmbientSound.play(normalWorldAmbientSoundTime)
		normalWorldNode.visible = true
		normalWorldNode.get_node("ParallaxBackground").visible = true
		deathWorldNode.visible = false
		deathWorldNode.get_node("DeathWorldBackground").visible = false
		#make normal world visible and collidable
	if (not normalWorld):
		normalWorldAmbientSoundTime = normalWorldAmbientSound.get_playback_position()
		normalWorldAmbientSound.stop()
		deathWorldAmbientSound.play(deathWorldAmbientSoundTime)
		normalWorldNode.visible = false
		normalWorldNode.get_node("ParallaxBackground").visible = false
		deathWorldNode.visible = true
		deathWorldNode.get_node("DeathWorldBackground").visible = true
		
func _on_player_damage(enemy : bool):
	normalWorldAmbientSound.volume_db = linear_to_db(1 - Game.playerHP/10)
	if (Game.playerHP < 5):
		AudioServer.set_bus_send(AudioServer.get_bus_index("AmbientSound"), "Master")


