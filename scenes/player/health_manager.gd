extends Node

@export var health_loss : int = 1
@onready var health_ticks : Timer = get_node("HealthTicks")

# Called when the node enters the scene tree for the first time.
func _ready():
	health_ticks.timeout.connect(_on_health_tick)
	Events.courage_depleted.connect(_on_courage_depleted)
	Events.courage_restored.connect(_on_courage_restored)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_courage_depleted():
	health_ticks.start()
	
func _on_courage_restored():
	health_ticks.stop()

func _on_health_tick():
	Game.playerHP -= health_loss
