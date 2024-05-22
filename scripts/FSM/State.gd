extends Node
class_name State

@onready var fsmManager = $".."

@onready var anim = $"../../AnimationPlayer"

@onready var rangedAttackDetection = $"../../RangedAttackDetectionArea"
@onready var attackDetection = $"../../AttackDetectionArea"
@onready var jumpAttackDetection = $"../../JumpAttackDetectionArea"

@onready var attackCooldown = $"../../AttackCooldown"

signal state_transition

func Enter():
	pass
	
func Update(delta: float):
	pass
	
func Exit():
	pass


