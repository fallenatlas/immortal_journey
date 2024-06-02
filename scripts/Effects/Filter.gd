extends ColorRect

@onready var lowestHP

# Called when the node enters the scene tree for the first time.
func _ready():
	lowestHP = Game.playerHP
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Game.resetShaders):
		lowestHP = Game.playerHP
		Game.resetShaders = false
	
	if (Game.playerHP < lowestHP):
		lowestHP = Game.playerHP
	
	var mappedHP = remap(lowestHP, Game.minHP, Game.maxHP, Game.maxSat, Game.minSat)
	var mappedCourage = remap(Game.courage, Game.minCourage, Game.maxCourage, Game.minBri, Game.maxBri)
	
	if not Game.isLastStand:
		# Saturation, from 0.3 to 1.2
		self.material.set_shader_parameter("saturation", mappedHP)
		# Brightness, from 0 to -0.2
		self.material.set_shader_parameter("brightness", mappedCourage)
	else:
		self.material.set_shader_parameter("saturation", Game.maxSat)
		# Brightness, from 0 to -0.2
		self.material.set_shader_parameter("brightness", Game.maxBri)
	pass
	

