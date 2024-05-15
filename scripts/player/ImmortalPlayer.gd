extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DASH_SPEED = 800.0
const DASH_LENGHT = 0.2

@onready var Dash = $Dash
@onready var DashEffect = $DashEffect

@onready var InvincibilityTimer = $InvincibilityPeriodManager/InvincibityTimer
@onready var ScreenShakeTimer = $InvincibilityPeriodManager/ScreenShakeTimer

@onready var Camera = $Camera2D

@onready var Sprite = $Sprite2D

@onready var Collider = $CollisionShape2D

@onready var AttackManager = $AttackManager

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed
var can_move = true
var time = 0
var damageTime = 0
var dashDirectionX = directionDash.nothing
var dashDirectionY = directionDash.nothing

var dying = false

@onready var anim = get_node("AnimationPlayer")

enum directionDash{
	left, 
	right, 
	up, 
	down,
	nothing
}

func _ready():
	Events.took_damage.connect(heal)

func _physics_process(delta):
	if Game.playerDead: #TODO: apply gravity even if he's dead
		if not is_on_floor():
			velocity.y += gravity * delta
			move_and_slide()
		return
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction == -1:
		get_node("Sprite2D").flip_h = true
		AttackManager.flip_horizontal(true)
	elif direction == 1:
		get_node("Sprite2D").flip_h = false
		AttackManager.flip_horizontal(false)
	
	if(!can_move):
		anim.play("Idle")
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#Handle Dash
	if Input.is_action_just_pressed("dash") && Dash.is_cooldown() && Game.courage >= 50:
		Dash.start_dash()
		dashDirectionX = calculate_direction_x()
		dashDirectionY = calculate_direction_y()
		DashEffect.emitting = true
	
	#var speed = DASH_SPEED if Dash.is_dashing() else SPEED
	if Dash.is_dashing():
		#speed = DASH_SPEED
		velocity = Vector2(0, 0)
		if(dashDirectionX == directionDash.left):
			if(dashDirectionY == directionDash.up):
				position += Vector2(-10, -10).normalized() * 10
			elif(dashDirectionY == directionDash.down):
				position += Vector2(-10, 10).normalized() * 10
			else:
				position += Vector2(-10, 0).normalized() * 10
		elif(dashDirectionX == directionDash.right):
			if(dashDirectionY == directionDash.up):
				position += Vector2(10, -10).normalized() * 10
			elif(dashDirectionY == directionDash.down):
				position += Vector2(10, 10).normalized() * 10
			else:
				position += Vector2(10, 0).normalized() * 10
		elif(dashDirectionX == directionDash.nothing && dashDirectionY ==directionDash.up):
			position += Vector2(0, -10).normalized() * 10
		elif(dashDirectionX == directionDash.nothing && dashDirectionY ==directionDash.down):
			position += Vector2(0, 10).normalized() * 10
		else:
			if(get_node("Sprite2D").flip_h == true):
				position += Vector2(-10, 0).normalized() * 10
			else:
				position += Vector2(10, 0).normalized() * 10
	else:
		speed = SPEED * remap(Game.courage, 0, 100, 0.5, 1)
		DashEffect.emitting = false
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * remap(Game.courage, 0, 100, 0.9, 1)
		if not AttackManager.is_attacking(): # || anim.current_animation != "Death" 
			anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * speed
		if velocity.y == 0:
			if not AttackManager.is_attacking(): # || anim.current_animation != "Death" 
				anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.y == 0:
			if not AttackManager.is_attacking(): # || anim.current_animation != "Death" 
				anim.play("Idle")
			
	if velocity.y > 0:
		if not AttackManager.is_attacking(): # || anim.current_animation != "Death"  
			anim.play("Fall")
	
	move_and_slide()
	
	#if Game.playerHP <= 0:
	#	dying = true
	#	anim.play("Death")
		
func _process(delta):
	#print(Game.isInvulnerable)
	if(!InvincibilityTimer.is_stopped()):
		time += delta * 2
		if(time > 1):
			time = 0
		Sprite.material.set_shader_parameter("time", time)
	if(!ScreenShakeTimer.is_stopped()):
		Camera.add_trauma(0.1)
		
	if Game.inSpikes == 0: damageTime = 1
	if Game.inSpikes > 0:
		damageTime += delta
		if damageTime >= 1:
			damageTime = 0
			Game.take_damage(1, true)
	

func get_direction():
	return Input.get_axis("move_left", "move_right")

func heal(enemy : bool):
	if Game.playerHP > 2:
		await get_tree().create_timer(0.5).timeout
	Game.playerHP = 10

func calculate_direction_x():
	var direction = Input.get_axis("move_left", "move_right")
	if(direction == -1):
		return directionDash.left
	elif(direction == 1):
		return directionDash.right
	else:
		return directionDash.nothing

func calculate_direction_y():
		if(Input.is_action_pressed("jump")):
			return directionDash.up
		elif(Input.is_action_pressed("move_down")):
			return directionDash.down
		else:
			return directionDash.nothing


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Death"):
		self.queue_free()
		get_tree().change_scene_to_file("res://scenes/main_menu/main.tscn")