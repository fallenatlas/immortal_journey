extends Area2D

@onready var popups : TutorialPopups = get_parent().get_node("../TutorialPopups")
@export var popup : TutorialPopups.MECHANIC

func _on_body_entered(body):
	popups.trigger(popup)
