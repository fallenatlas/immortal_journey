extends ColorRect

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	#self.material.set_shader_parameter("vignette_rgb", Color(255, 255, 255, 1))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	time += delta
	#if time > 1:
		#time = 0
	
	var mappedHP = remap(Game.playerHP, Game.minHP, Game.maxHP, 0, 1)
	var mappedCourage = remap(Game.courage, Game.minCourage, Game.maxCourage, 1, 0)
	
	var mappedColorRed = lerp(Game.redColor.r, Game.whiteColor.r, 0.5 + mappedHP - 0.1)
	var mappedColorGreen = lerp(Game.redColor.g, Game.whiteColor.g, mappedHP - 0.1)
	var mappedColorBlue = lerp(Game.redColor.b, Game.whiteColor.b, mappedHP - 0.1)
	
	#print(str(mappedColorRed) + " " + str(mappedColorGreen) + " " + str(mappedColorBlue) + str(mappedCourage))
	
	# Vignette
	#BUG: Color are kinda weird, I don't exactly know how they mix in the shaders
	self.material.set_shader_parameter("vignette_rgb", Color(mappedColorRed, mappedColorGreen, mappedColorBlue, mappedHP))
	
	self.material.set_shader_parameter("mappedHP", mappedHP);
	#Pulsating effect
	self.material.set_shader_parameter("time", time * 2);
	
