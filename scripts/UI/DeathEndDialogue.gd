extends Area2D

var cutsceneEnded = false

	
func use_dialogue():

	var dialogue = get_parent().get_node("DialogueBox")
	
	if dialogue:
		dialogue.start("DeathEnd")
		
	
func _on_body_entered(body):
	if body.name == "Player" and not cutsceneEnded:
		cutsceneEnded = true
		use_dialogue()
	
