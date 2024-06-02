extends ParallaxBackground

var scrolling_speed = 100

func _process(delta):
	if get_tree().current_scene.name == "Main":
		scroll_base_offset.x -= scrolling_speed * delta
	else:
		scroll_offset.x -= scrolling_speed * delta		
