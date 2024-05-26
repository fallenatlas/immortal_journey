extends HBoxContainer

@onready var dash_bar : TextureProgressBar = $MarginContainer/TextureProgressBar

@onready var dash_ready_look = load("res://Health Bar Asset Pack 2 by Adwit Rahman/dash_ready__2d.tres")
@onready var dash_not_ready_look = load("res://Health Bar Asset Pack 2 by Adwit Rahman/dash_progress_2d.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if Game.courage <= Game.MIN_COURAGE_DASH:
		#simbol cor grey out
		dash_bar.value = 2
		dash_bar.texture_progress = dash_not_ready_look
		#dash_bar.tint_progress = Color(0, 0, 0, 0.5)
		return
	
	#simbol cor normal
	dash_bar.tint_progress = Color(1, 1, 1, 1)
	if Game.is_dash_ready:
		#simbol cor normal
		dash_bar.texture_progress = dash_ready_look
		dash_bar.tint_progress = Color(1, 1, 1, 1)
		dash_bar.value = 2
	else:
		dash_bar.texture_progress = dash_not_ready_look
		dash_bar.value = Game.dash_recharge_time
