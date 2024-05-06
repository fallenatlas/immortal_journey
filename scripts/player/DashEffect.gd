extends GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#texture = load("res://Martial Hero/PNG/Idle/1.png")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#texture = sprite.texture
	#BUG: Can't flip the texture to when you dash to the left
	var img : Texture2D = self.texture;
	
	#if(!get_parent().get_direction() == 1):
		#img.flip_x()
		
	#self.texture = img
