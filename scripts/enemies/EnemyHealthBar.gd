extends TextureProgressBar

@onready var body = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	if body is CanvasLayer:
		body = $"../.."
	max_value = body.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = body.health
