extends State
class_name PlayerAttack1

@onready var fsmManager = $".."

@onready var anim = $"../../AnimationPlayer"

@onready var rangedAttackDetection = $"../../RangedAttackDetectionArea"
@onready var attackDetection = $"../../AttackDetectionArea"
@onready var jumpAttackDetection = $"../../JumpAttackDetectionArea"

@onready var attackCooldown = $"../../AttackCooldown"

func Enter():
	anim.play("Attack1")
	attackCooldown.start()
	
func Update(delta: float):
	pass

func Exit():
	pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack1":
		fsmManager.change_state(self, "Idle")
