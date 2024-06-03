extends Area2D

var cutsceneEnded = false

	
func use_dialogue():

	var dialogue = get_parent().get_node("DialogueBox")
	
	if dialogue:
		dialogue.start("Death", "End")
		
	
func _on_body_entered(body):
	if body.name == "Player" and not cutsceneEnded:
		Events.switch_world.emit(true)
		body.change_camera_limits(29408, -213, 30137, 198)
		Events.boss_fight.emit()
		cutsceneEnded = true
		use_dialogue()
	
