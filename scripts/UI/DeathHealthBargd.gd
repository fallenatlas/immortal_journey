extends TextureProgressBar

@onready var body = $"../.."

var textureRedBar 
var textureGreyBar

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = body.health
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = body.health

