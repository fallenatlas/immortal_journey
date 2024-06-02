extends Area2D

var cutsceneEnded = false

	
func use_dialogue():

	var dialogue = get_parent().get_node("DialogueBox")
	
	if dialogue:
		dialogue.start("Death", "End")
		
	
func _on_body_entered(body):
	if body.name == "Player" and not cutsceneEnded:
		cutsceneEnded = true
		use_dialogue()
	
