extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.material.set_shader_parameter("vignette_rgb", Color(255, 255, 255, 1))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mappedHP = remap(Game.playerHP, Game.minHP, Game.maxHP, 0, 1)
	var mappedCourage = remap(Game.courage, Game.minCourage, Game.maxCourage, 1, 0)
	
	var mappedColorRed = lerp(Game.redColor.r, Game.whiteColor.r, mappedHP)
	var mappedColorGreen = lerp(Game.redColor.g, Game.whiteColor.g, mappedHP)
	var mappedColorBlue = lerp(Game.redColor.b, Game.whiteColor.b, mappedHP)
	
	#print(str(mappedColorRed) + " " + str(mappedColorGreen) + " " + str(mappedColorBlue) + str(mappedCourage))
	
	# Vignette
	#BUG: Color are kinda weird, I don't exactly know how they mix in the shaders
	self.material.set_shader_parameter("vignette_rgb", Color(mappedColorRed, mappedColorGreen, mappedColorBlue, mappedCourage))
	
	
