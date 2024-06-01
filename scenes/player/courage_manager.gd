extends Node

@export var courage_loss : int = 5
@onready var courage_ticks : Timer = get_node("CourageTicks")

# Called when the node enters the scene tree for the first time.
func _ready():
	courage_ticks.timeout.connect(_on_courage_tick)
	Events.switch_world.connect(_on_switch_world)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		courage_ticks.stop()
		#reset time?
	elif (not normalWorld):
		Game.courage -= courage_loss
		courage_ticks.start()

func _on_courage_tick():
	if not Game.isImmortal:
		Game.courage -= courage_loss
	#something is gonna have to expell us from the other world if were there
