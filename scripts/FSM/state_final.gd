extends State
class_name FinalState

@onready var fsmManager = $".."
@onready var body = $"../.."
@onready var anim = $"../../AnimationPlayer"

func Enter():
	anim.play("Teleport")
	await anim.animation_finished
	anim.play("Idle")
	
func Update(delta: float):
	pass

func Exit():
	pass

