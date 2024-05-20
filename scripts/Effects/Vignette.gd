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
	print(sin(time))

	var mappedHP = remap(Game.playerHP, Game.minHP, Game.maxHP, 0, 1)
	var mappedHalfHP = remap(Game.playerHP, Game.minHP, Game.maxHP/2, 0, 1)
	
	var mappedCourage = remap(Game.courage, Game.minCourage, Game.maxCourage, 1, 0)
	
	var mappedColorRed = lerp(Game.redColor.r, Game.softRedColor.r, mappedHalfHP)
	var mappedColorGreen = lerp(Game.redColor.g, Game.softRedColor.g, mappedHalfHP)
	var mappedColorBlue = lerp(Game.redColor.b, Game.softRedColor.b, mappedHalfHP)
	
	#print(str(mappedColorRed) + " " + str(mappedColorGreen) + " " + str(mappedColorBlue) + str(mappedCourage))
	
	# Vignette
	#BUG: Color are kinda weird, I don't exactly know how they mix in the shaders
	self.material.set_shader_parameter("vignette_rgb", Color(mappedColorRed, mappedColorGreen, mappedColorBlue, 1))
	
	self.material.set_shader_parameter("mappedHP", mappedHP);
	#Pulsating effect
	#O valor 5.6 nao sei porque é que é o correto
	self.material.set_shader_parameter("time", time * 5.6);
	
