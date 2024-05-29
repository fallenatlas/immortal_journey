extends State
class_name DragonDashState

@export var SPEED = 7000

@onready var body = $"../.."

@onready var fsmManager = $".."

@onready var anim = $"../../AnimationPlayer"

@onready var attackDetection = $"../../AttackDetectionArea"
@onready var attackCooldown = $"../../AttackCooldown"

@onready var patrolTimer = $"../../PatrolTimer"

@onready var attackSound = $"../../AttackSound"
@onready var deathSound = $"../../DeathSound"

var direction

var player

func Enter():
	anim.play("Dash")
	attackSound.play()
	player = get_node("../../../../Player/Player")
	direction = (player.global_position - body.global_position).normalized()
	
func Update(delta: float):
	
	body.velocity = direction * 10000 * delta
	
func Exit():
	pass

func _stop_movement():
	direction = Vector2(0, 0)
	deathSound.play()
	
func explode_logic():
	body.explode()
