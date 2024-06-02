extends TextureProgressBar

@onready var ThresholdIndicator = $ThresholdIndicator
@onready var ThresholdIcon = $ThresholdIcon

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.dash_threshold_change.connect(_dash_threshold_change)
	Events.last_stand.connect(_change_courage_bar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = Game.courage
	
func _dash_threshold_change():
	visible = !visible
	
func _change_courage_bar():
	var image1 = Image.load_from_file("res://Health Bar Asset Pack 2 by Adwit Rahman/CourageBarover3x.png")
	var image2 = Image.load_from_file("res://Health Bar Asset Pack 2 by Adwit Rahman/BarBackground.png")
	var image3 = Image.load_from_file("res://Health Bar Asset Pack 2 by Adwit Rahman/CourageBarProgress3xDashUp.png")
	var over = ImageTexture.create_from_image(image1)
	var under = ImageTexture.create_from_image(image2)
	var progress = ImageTexture.create_from_image(image3)
	
	set_over_texture(over)
	set_progress_texture(progress)
	set_under_texture(under)
	
	$ThresholdIndicator.visible = false
