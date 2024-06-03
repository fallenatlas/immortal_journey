extends Area2D

@onready var popup = $Popup

func _process(delta):
		popup.visible = has_overlapping_bodies()
	
func _input(event):
	if event.is_action_pressed("interact") and len(get_overlapping_bodies()) > 0:
		use_dialogue()
		

func use_dialogue():
	var dialogue = get_parent().get_node("DialogueBox")
	
	if dialogue:
		dialogue.start(get_parent().name)
		
