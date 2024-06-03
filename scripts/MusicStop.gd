extends Area2D

@export var next : int = 0

func _on_body_entered(body):
	Events.music_stop.emit()
