extends CanvasLayer


func fade_to_scene():
	$AnimationPlayer.play("Fade")
	
func change_scene():
	get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
