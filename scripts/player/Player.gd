extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DASH_SPEED = 800.0
const DASH_LENGHT = 0.2

@onready var Dash = $Dash
@onready var DashEffect = $DashEffect

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed

@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
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
	
	
	if direction == -1:
		get_node("Sprite2D").flip_h = true
	elif direction == 1:
		get_node("Sprite2D").flip_h = false
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

func get_direction():
	return Input.get_axis("move_left", "move_right")

