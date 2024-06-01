extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.last_stand.connect(_on_last_stand)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = Game.playerHP


func _on_last_stand():
	visible = false
