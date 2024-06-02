extends State
class_name FinalState

@onready var fsmManager = $".."
@onready var body = $"../.."
@onready var anim = $"../../AnimationPlayer"

func Enter():
	Events.switch_world.emit(true)
	Game.canChangeWorlds = false
	Game.lastStandDrain = 0
	Game.playerHP = 10
	Game.courage = 100
	Events.cutscene_finished.connect(_final_choice)
	Events.choice_made.connect(play_disappear_animation)
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

func _disappear():
	body.queue_free()
	
func play_disappear_animation():
	anim.play("FinalTeleport")
