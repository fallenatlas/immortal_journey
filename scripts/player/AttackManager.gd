extends Node2D

var attacking : bool = false
var attack_1 : bool = false
var attack_2 : bool = false
var attackAreaRotation : float

@onready var outerTimer : Timer = get_node("OuterAttackTimer")
@onready var longerOuterTimer : Timer = get_node("LongerOuterAttackTimer")
@onready var innerTimer : Timer = get_node("InnerAttackTimer")
@onready var readyUpTimer : Timer = get_node("ReadyUpTimer")

@onready var anim : AnimationPlayer = get_parent().get_node("AnimationPlayer")
@onready var attackArea : Area2D = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	attackAreaRotation = attackArea.rotation_degrees
	Events.switch_world.connect(_on_switch_world)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(attackArea.monitoring)
	if (Game.playerDead or is_attacking()):
		return
		
	if (Input.is_action_just_pressed("strike") and can_attack()):
		anim.play("Attack_1")
		get_parent().create_sound("Attack")
		attack_1 = true
		#readyUpTimer.start()
		#attack_enemies_in_range()
		
	if (Input.is_action_just_pressed("strike") and not innerTimer.is_stopped()):
		outerTimer.stop()
		anim.play("Attack_2")
		get_parent().create_sound("Attack")
		attack_2 = true
		#readyUpTimer.start()
		#attack_enemies_in_range()

func is_attacking() -> bool:
	return attack_1 or attack_2
	
func flip_horizontal(value : bool) -> void:
	if value:
		attackArea.rotation_degrees = -attackAreaRotation
	else:
		attackArea.rotation_degrees = attackAreaRotation

func can_attack() -> bool:
	return outerTimer.is_stopped() and longerOuterTimer.is_stopped()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack_1":
		attack_1 = false
		innerTimer.start()
		outerTimer.start()
	elif anim_name == "Attack_2":
		attack_2 = false
		longerOuterTimer.start()

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
