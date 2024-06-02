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

var direction

var player

var isExploding = false

func Enter():
	anim.play("Dash")
	attackSound.play()
	player = get_node("../../../../Player/Player")
	
	
func Update(delta: float):
	if not isExploding:
		direction = (player.global_position - body.global_position).normalized()
	body.velocity = direction * 10000 * delta
	
func Exit():
	pass

func _stop_movement():
	isExploding = true
	direction = Vector2(0, 0)
	
func explode_logic():
	body.explode()
