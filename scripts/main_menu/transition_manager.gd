extends CanvasLayer

var scene_transition

func fade_to_scene(sceneName : String):
	$AnimationPlayer.play("Fade")
	scene_transition = sceneName
	
func change_scene():
	match scene_transition:
		"immortal":
			change_to_immortal_scene()
		"world":
			change_to_level1_scene()
		_:
			pass
	
func change_to_immortal_scene():
	get_tree().change_scene_to_file("res://scenes/areas/immortal.tscn")
	
func change_to_level1_scene():
	get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
