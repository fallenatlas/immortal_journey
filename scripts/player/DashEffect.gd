extends GPUParticles2D

var normaltexture
var textureInverted

# Called when the node enters the scene tree for the first time.
func _ready():
	normaltexture = load("res://Martial Hero/PNG/Idle/1.png")
	textureInverted = load("res://Martial Hero/PNG/Idle/1Inverted.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#texture = sprite.texture
	#BUG: Can't flip the texture to when you dash to the left
	
	if(!get_parent().get_direction() == 1):
		texture = textureInverted
	else:
		texture = normaltexture
	
