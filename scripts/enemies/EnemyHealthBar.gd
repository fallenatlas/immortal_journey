extends TextureProgressBar

@onready var archer = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = archer.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = archer.health
