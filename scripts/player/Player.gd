extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DASH_SPEED = 800.0
const DASH_LENGHT = 0.2

@onready var Dash = $Dash
@onready var DashEffect = $DashEffect

@onready var OtherWorldEffect = $"../../Visual Effects/OtherWorld"

@onready var InvincibilityTimer = $InvincibilityPeriodManager/InvincibityTimer
@onready var ScreenShakeTimer = $InvincibilityPeriodManager/ScreenShakeTimer

@onready var Camera = $Camera2D

@onready var Sprite = $Sprite2D

@onready var Collider = $CollisionShape2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed

var can_move = true

var time = 0

@onready var anim = get_node("AnimationPlayer")

func _ready():
	Events.switch_world.connect(_on_switch_world)
	Events.took_damage.connect(be_invincible)

func _physics_process(delta):
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction == -1:
		get_node("Sprite2D").flip_h = true
	elif direction == 1:
		get_node("Sprite2D").flip_h = false
	
	if(!can_move):
		anim.play("Idle")
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#Handle Dash
	if Input.is_action_just_pressed("dash") && Dash.is_cooldown(): # && Game.courage >= 50
		Dash.start_dash()
		DashEffect.emitting = true
	
	#var speed = DASH_SPEED if Dash.is_dashing() else SPEED
	if Dash.is_dashing():
		#speed = DASH_SPEED
		if(direction == 1):
			position += Vector2(10, 0)
		else:
			position += Vector2(-10, 0)
		velocity.y = 0

	else:
		speed = SPEED
		DashEffect.emitting = false
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * speed
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.y == 0:
			anim.play("Idle")
			
	if velocity.y > 0:
		anim.play("Fall")
	
	move_and_slide()
	
	if Game.playerHP <= 0:
		self.queue_free()
		get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")
		
func _process(delta):
	if(!InvincibilityTimer.is_stopped()):
		time += delta * 2
		if(time > 1):
			time = 0
		Sprite.material.set_shader_parameter("time", time)
	if(!ScreenShakeTimer.is_stopped()):
		Camera.add_trauma(0.1)
	

func get_direction():
	return Input.get_axis("move_left", "move_right")

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		set_collision_mask_value(2, true)
		set_collision_mask_value(4, true)
		set_collision_mask_value(5, false)
		set_collision_mask_value(7, false)
	if (not normalWorld):
		set_collision_mask_value(2, false)
		set_collision_mask_value(4, false)
		set_collision_mask_value(5, true)
		set_collision_mask_value(7, true)


func be_invincible():
	InvincibilityTimer.start()
	ScreenShakeTimer.start()
	
func _on_invincibity_timer_timeout():
	Sprite.material.set_shader_parameter("time", 0)
	Game.isInvulnerable = false
