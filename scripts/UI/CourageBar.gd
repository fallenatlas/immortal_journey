extends TextureProgressBar

@onready var ThresholdIndicator = $ThresholdIndicator
@onready var ThresholdIcon = $ThresholdIcon

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.dash_threshold_change.connect(_dash_threshold_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = Game.courage
	
func _dash_threshold_change():
	visible = true
	
