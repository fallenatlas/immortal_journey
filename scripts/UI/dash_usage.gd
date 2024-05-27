extends HBoxContainer

@onready var dash_icon : TextureRect = $TextureRect
@onready var dash_bar : TextureProgressBar = $MarginContainer/TextureProgressBar

@onready var dash_ready_look = load("res://Health Bar Asset Pack 2 by Adwit Rahman/dash_ready__2d.tres")
@onready var dash_not_ready_look = load("res://Health Bar Asset Pack 2 by Adwit Rahman/dash_progress_2d.tres")
@onready var dash_icon_available = load("res://assets/ui/kisspng-brand-line-logo-number-technology-sprite-arrow-5b3ee609de7cb2.3924113515308487779113.png")
@onready var dash_icon_unavailable = load("res://assets/ui/dash_unavailable.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if Game.courage <= Game.MIN_COURAGE_DASH:
		#simbol cor grey out
		dash_bar.value = 2
		dash_icon.texture = dash_icon_unavailable
		dash_bar.texture_progress = dash_not_ready_look
		#dash_bar.tint_progress = Color(0, 0, 0, 0.5)
		return
	
	#simbol cor normal
	dash_bar.tint_progress = Color(1, 1, 1, 1)
	dash_icon.texture = dash_icon_available
	if Game.is_dash_ready:
		#simbol cor normal
		dash_bar.texture_progress = dash_ready_look
		dash_bar.tint_progress = Color(1, 1, 1, 1)
		dash_bar.value = 2
	else:
		dash_bar.texture_progress = dash_not_ready_look
		dash_bar.value = Game.dash_recharge_time
