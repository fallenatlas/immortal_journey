extends State
class_name DragonDashState

@export var SPEED = 7000

@onready var body = $"../.."

@onready var fsmManager = $".."

@onready var anim = $"../../AnimationPlayer"

@onready var attackDetection = $"../../AttackDetectionArea"
@onready var attackCooldown = $"../../AttackCooldown"

@onready var patrolTimer = $"../../PatrolTimer"

var direction

var player

func Enter():
	anim.play("Dash")
	
	player = get_node("../../../../Player/Player")
	direction = (player.position - body.position).normalized()
	#BUG: Direction is not right
	direction.y += 1
	
func Update(delta: float):
	
	body.velocity = direction * 10000 * delta
	
func Exit():
	pass

func _stop_movement():
	direction = Vector2(0, 0)
	
func explode_logic():
	body.explode()
