extends Node2D

var max_attacks : int = 3:
	set(value):
		Game.attack_buffer = value
		max_attacks = value

var current_attack : int = 0
var attackAreaRotation : float

@onready var outerTimer : Timer = get_node("OuterAttackTimer")
@onready var innerTimer : Timer = get_node("InnerAttackTimer")
@onready var readyUpTimer : Timer = get_node("ReadyUpTimer")

@onready var anim : AnimationPlayer = get_parent().get_node("AnimationPlayer")
@onready var attackArea : Area2D = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	attackAreaRotation = attackArea.rotation_degrees
	Events.switch_world.connect(_on_switch_world)
	Game.attack_buffer = max_attacks

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_inner_timer()
	update_outer_timer()
	
	if (Game.playerDead or is_attacking() or Game.attack_buffer <= 0 or not Game.playerCanMove):
		return
		
	if (!Input.is_action_just_pressed("strike")):
		return
		
	if (current_attack != 0 and !outerTimer.is_stopped() and innerTimer.is_stopped()):
		return
		
	print(outerTimer.wait_time)
		
	current_attack = next_attack()

	innerTimer.stop()
	outerTimer.stop()
	if (current_attack % 2 == 0):
		anim.play("Attack_1")
	else:
		anim.play("Attack_2")
	get_parent().create_sound("Attack")
	Game.attack_buffer -= 1

	
func is_attacking() -> bool:
	return anim.current_animation == "Attack_1" or anim.current_animation == "Attack_2"
	
func flip_horizontal(value : bool) -> void:
	if value:
		attackArea.rotation_degrees = -attackAreaRotation
	else:
		attackArea.rotation_degrees = attackAreaRotation
	
func next_attack() -> int:
	return current_attack + 1

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack_1" or anim_name == "Attack_2":
		innerTimer.start()
		outerTimer.start()

#func attack_enemies_in_range():
#	var bodies = attackArea.get_overlapping_bodies()
#	for body in bodies:
#		print("body")
#		if body.get_groups().has("Enemy"):
#			body.death()
			

func _on_ready_up_timer_timeout():
	if (Game.playerDead):
		return
	var bodies = attackArea.get_overlapping_bodies()
	for body in bodies:
		if body.get_groups().has("Enemy"):
			body.death()

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		attackArea.set_collision_mask_value(4, true)
		attackArea.set_collision_mask_value(7, false)
	else:
		attackArea.set_collision_mask_value(4, false)
		attackArea.set_collision_mask_value(7, true)


func _on_area_2d_body_entered(body):
	if (Game.playerDead):
		return
	if body.get_groups().has("Enemy") && attackArea.monitoring == true:
		body.death()


func _on_outer_attack_timer_timeout():
	Game.outer_timer_time = 0
	Game.attack_buffer += 1
	if (Game.attack_buffer < max_attacks):
		outerTimer.start()


func _on_inner_attack_timer_timeout():
	current_attack = 0

func update_inner_timer() -> void:
	Game.is_sword_combo_active = (is_attacking() or !innerTimer.is_stopped()) and Game.attack_buffer > 0 and current_attack != 0 
	
func update_outer_timer() -> void:
	if outerTimer.is_stopped():
		Game.outer_timer_time = 0
		return
	Game.outer_timer_time = outerTimer.wait_time - outerTimer.time_left
	if Game.outer_timer_time < 0.1:
		Game.outer_timer_time = 0
	
