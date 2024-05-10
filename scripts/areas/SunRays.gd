extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.switch_world.connect(_on_switch_world)


func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		self.visible = true
	if (not normalWorld):
		self.visible = false
