extends State
class_name DragonIdleState

@export var SPEED = 5000

@onready var body = $"../.."
@onready var sprite = $"../../Sprite2D"

@onready var fsmManager = $".."

@onready var anim = $"../../AnimationPlayer"

@onready var attackDetection = $"../../AttackDetectionArea"
@onready var attackCooldown = $"../../AttackCooldown"

@onready var patrolTimer = $"../../PatrolTimer"

var direction

func Enter():
	anim.play("Idle")
	direction = Vector2(1, 0).normalized()
	patrolTimer.start()
	
func Update(delta: float):
	
	body.velocity = direction * 5000 * delta
	

func Exit():
	pass


func _on_patrol_timer_timeout():
	direction = - direction
	patrolTimer.start()


func _on_detection_area_body_entered(body):
	if body.name == "Player":
		fsmManager.force_change_state("Dash")
