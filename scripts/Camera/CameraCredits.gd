extends Camera2D

var scrolling_speed_x = 100
var scrolling_speed_y = 0
var direction = 1

func _process(delta):

	if position.x > 4200:
		if scrolling_speed_y > 60: direction = -1
		scrolling_speed_x = max(0, scrolling_speed_x - 0.215)
		scrolling_speed_y = max(0, scrolling_speed_y + 0.25 * direction)
		position.y -= (scrolling_speed_y) * delta
	position.x += scrolling_speed_x * delta
	if scrolling_speed_x == 0 && $"../Timer".is_stopped():
		$"../Timer".start()


func _on_timer_timeout():
	TransitionManager.fade_to_scene("end")
