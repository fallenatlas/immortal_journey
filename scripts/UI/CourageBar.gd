extends TextureProgressBar

@onready var ThresholdIndicator = $ThresholdIndicator
@onready var ThresholdIcon = $ThresholdIcon

@onready var lastStandDrain = $LastStandDrain

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.dash_threshold_change.connect(_dash_threshold_change)
	Events.last_stand.connect(_on_last_stand)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = Game.courage
	
func _dash_threshold_change():
	visible = true
	


func _on_last_stand():
	#$"..".scale.x = 3
	Game.isLastStand = true
	lastStandDrain.start()
	
	var image1 = Image.load_from_file("res://Health Bar Asset Pack 2 by Adwit Rahman/BarBackground.png")
	var image2 = Image.load_from_file("res://Health Bar Asset Pack 2 by Adwit Rahman/CourageBarover3x.png")
	var image3 = Image.load_from_file("res://Health Bar Asset Pack 2 by Adwit Rahman/CourageBarProgress3x.png")
	var texture1 = ImageTexture.create_from_image(image1)
	var texture2 = ImageTexture.create_from_image(image2)
	var texture3 = ImageTexture.create_from_image(image3)
	
	set_under_texture(texture1)
	set_over_texture(texture2)
	set_progress_texture(texture3)


func _on_last_stand_drain_timeout():
	Game.courage -= 3
	lastStandDrain.start()
