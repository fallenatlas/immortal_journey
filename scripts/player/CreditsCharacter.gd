extends AnimatedSprite2D

var scrolling_speed = 100

func _process(delta):
	position.x += scrolling_speed * delta
