extends State
class_name DeathCutsceneState

@onready var fsmManager = $".."

@onready var anim = $"../../AnimationPlayer"

@onready var rangedAttackDetection = $"../../RangedAttackDetectionArea"
@onready var attackDetection = $"../../AttackDetectionArea"
@onready var jumpAttackDetection = $"../../JumpAttackDetectionArea"

@onready var attackCooldown = $"../../AttackCooldown"



func Enter():
	anim.play("Idle")
	Events.death_cutscene_finished.connect(switch_state)
	
func Update(delta: float):
	pass

func Exit():
	pass

func switch_state():
	fsmManager.change_state(self, "Idle")
