extends Node2D

@onready var normalWorldNode = get_node("NormalWorld")
@onready var deathWorldNode = get_node("DeathWorld")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.playerHP = 10
	Game.courage = 50.0
	Events.switch_world.connect(_on_switch_world)
	Events.courage_depleted.connect(_on_courage_depleted)

func _process(delta):
	if Input.is_action_just_pressed("swith_world"):
		#still a bit bugy but overall well
		#thing about having some indication of how the other world is
		var map : TileMap = normalWorldNode.get_node("TileMap")
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
		normalWorldNode.visible = true
		normalWorldNode.get_node("ParallaxBackground").visible = true
		deathWorldNode.visible = false
		deathWorldNode.get_node("DeathWorldBackground").visible = false
		#make normal world visible and collidable
	if (not normalWorld):
		normalWorldNode.visible = false
		normalWorldNode.get_node("ParallaxBackground").visible = false
		deathWorldNode.visible = true
		deathWorldNode.get_node("DeathWorldBackground").visible = true
		
