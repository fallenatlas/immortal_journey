extends TextureProgressBar

@onready var ThresholdIndicator = $ThresholdIndicator
@onready var ThresholdIcon = $ThresholdIcon

var image1 = load("res://Health Bar Asset Pack 2 by Adwit Rahman/CourageBarover3x.png")
var image2 = load("res://Health Bar Asset Pack 2 by Adwit Rahman/BarBackground.png")
var image3 = load("res://Health Bar Asset Pack 2 by Adwit Rahman/CourageBarProgress3xDashUp.png")

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
	
	set_over_texture(image1)
	set_progress_texture(image3)
	set_under_texture(image2)
	
	$ThresholdIndicator.visible = false
