extends Camera2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

@export var jump_decay = 0.9  # How quickly the shaking stops [0, 1].
@export var jump_max_offset = Vector2(0, 75)  # Maximum hor/ver shake in pixels.
@export var jump_max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var jump_trauma = 0.0
var jump_trauma_power = 2

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
	
func add_jump_trauma(amount):
	jump_trauma = min(jump_trauma + amount, 1.0)

func _process(delta):
	if jump_trauma:
		jump_trauma = max(jump_trauma - jump_decay * delta, 0)
		jump_shake()
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func jump_shake():
	var amount = pow(jump_trauma, jump_trauma_power)
	offset.y = jump_max_offset.y * amount * randf_range(-1, 1)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)

func change_camera_limits(left_limit, top_limit, right_limit, bottom_limit):
	limit_left = left_limit
	limit_top = top_limit
	limit_right = right_limit
	limit_bottom = bottom_limit
	limit_smoothed
