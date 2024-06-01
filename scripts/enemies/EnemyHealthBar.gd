extends TextureProgressBar

@onready var body = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	if body is CanvasLayer:
		body = $"../.."
	max_value = body.health
	Events.switch_world.connect(_on_switch_world)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = body.health

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		visible = true
	if (not normalWorld):
		visible = false
	
