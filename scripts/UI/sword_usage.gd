extends HBoxContainer

@onready var attack_1 : TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var attack_2 : TextureProgressBar = $MarginContainer2/TextureProgressBar2
@onready var attack_3 : TextureProgressBar = $MarginContainer3/TextureProgressBar3

@onready var attack_ready_look = load("res://Health Bar Asset Pack 2 by Adwit Rahman/sword_progress_2d.tres")
@onready var attack_not_ready_look = load("res://Health Bar Asset Pack 2 by Adwit Rahman/sword_reloading_2d.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.attack_buffer == 0:
		attack_1.texture_progress = attack_not_ready_look
		attack_1.value = Game.outer_timer_time #this one should be more transparent
		attack_2.value = 0.0
		attack_3.value = 0.0
	elif Game.attack_buffer == 1:
		attack_1.texture_progress = attack_ready_look
		attack_1.value = 0.5
		attack_2.texture_progress = attack_not_ready_look
		attack_2.value = Game.outer_timer_time
		attack_3.value = 0.0
	elif Game.attack_buffer == 2:
		attack_1.value = 0.5
		attack_2.texture_progress = attack_ready_look
		attack_2.value = 0.5
		attack_3.texture_progress = attack_not_ready_look
		attack_3.value = Game.outer_timer_time
	elif Game.attack_buffer == 3:
		attack_1.value = 0.5
		attack_2.value = 0.5
		attack_3.texture_progress = attack_ready_look
		attack_3.value = 0.5
		
	if Game.is_sword_combo_active:
		if Game.attack_buffer == 1:
			#activate gold color or something
			attack_1.tint_progress = Color(255/255, 83/255, 57/255, 1)
		elif Game.attack_buffer == 2:
			attack_2.tint_progress = Color(255/255, 83/255, 57/255, 1)
		elif Game.attack_buffer == 3:
			attack_3.tint_progress = Color(255/255, 83/255, 57/255, 1)
	else:
		attack_1.tint_progress = Color(1, 1, 1, 1)
		attack_2.tint_progress = Color(1, 1, 1, 1)
		attack_3.tint_progress = Color(1, 1, 1, 1)
