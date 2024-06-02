extends State
class_name FinalState

@onready var fsmManager = $".."
@onready var body = $"../.."
@onready var anim = $"../../AnimationPlayer"

func Enter():
	Events.cutscene_finished.connect(_final_choice)
	anim.play("Teleport")
	await anim.animation_finished
	anim.play("Idle")
	
	var dialogue = $"../../DialogueBox"
	if dialogue:
		dialogue.start("Death", "Defeated")
	
func Update(delta: float):
	pass

func Exit():
	pass


func _final_choice():
	Events.final_choice.emit()
