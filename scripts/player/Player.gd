extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const DASH_SPEED = 800.0
@onready var DashLenght = 10

@onready var Dash = $Dash
@onready var DashEffect = $DashEffect

@onready var OtherWorldEffect = $"../../Visual Effects/OtherWorld"

@onready var InvincibilityTimer = $InvincibilityPeriodManager/InvincibityTimer
@onready var ScreenShakeTimer = $InvincibilityPeriodManager/ScreenShakeTimer

@onready var Camera = $Camera2D

@onready var Sprite = $Sprite2D

@onready var Collider = $CollisionShape2D

@onready var AttackManager = $AttackManager

@onready var CoyoteTimer = $CoyoteTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed
var time = 0
var damageTime = 0

var isJumping = false
var isPossibleCoyote = true

var dying = false

@onready var anim = get_node("AnimationPlayer")
@onready var audioPlayer = preload("res://scenes/player/Audio_Player.tscn")
@onready var runSound = get_node("RunSound")
@onready var damageSound = get_node("DamageSound")
@onready var breathingSound = get_node("HeavyBreathingSound")
@onready var heartbeatSound = get_node("HeartbeatSound")

func _ready():
	Events.switch_world.connect(_on_switch_world)
	Events.took_damage.connect(be_invincible)
	Events.took_damage.connect(_on_player_damage)

func _physics_process(delta):
	if Game.playerDead: #TODO: apply gravity even if he's dead
		if not is_on_floor():
			velocity.y += gravity * delta
			move_and_slide()
		return
	
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0:
		get_node("Sprite2D").flip_h = true
		AttackManager.flip_horizontal(true)
	elif direction > 0:
		get_node("Sprite2D").flip_h = false
		AttackManager.flip_horizontal(false)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if(!Game.playerCanMove):
		anim.play("Idle")
		velocity.x = 0
		move_and_slide()
		return

	#Handle Dash
	if Input.is_action_just_pressed("dash") && Dash.is_cooldown() && Game.courage >= Game.min_courage_dash:
		print(Game.min_courage_dash)
		print("distance")
		print(DashLenght)
		Dash.start_dash()
		create_sound("Dash", self.global_transform.origin)
		DashEffect.emitting = true
	
	#var speed = DASH_SPEED if Dash.is_dashing() else SPEED
	if Dash.is_dashing():
		var dash_direction = calculate_dash_direction()
		
		if (dash_direction == Vector2(0.0, 0.0)):
			if(get_node("Sprite2D").flip_h == true):
				position += Vector2(-DashLenght, 0)
			else:
				position += Vector2(DashLenght, 0)
		else:
			velocity = Vector2(0, 0)
			position += dash_direction * DashLenght
	else:
		speed = SPEED * remap(Game.courage, 0, 100, 0.5, 1)
		DashEffect.emitting = false
	
	if is_on_floor():
		isJumping = false
		isPossibleCoyote = true
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and not isJumping and (is_on_floor() or not CoyoteTimer.is_stopped()):
		velocity.y = JUMP_VELOCITY #* remap(Game.courage, 0, 100, 0.9, 1)
		isJumping = true
		if not AttackManager.is_attacking(): # || anim.current_animation != "Death" 
			anim.play("Jump")
			create_sound("Jump", self.global_transform.origin)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * speed

		if velocity.y == 0:
			if not AttackManager.is_attacking(): # || anim.current_animation != "Death" 
				anim.play("Run")
				if !runSound.playing:
					runSound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		if velocity.y == 0:
			if not AttackManager.is_attacking(): # || anim.current_animation != "Death" 
				anim.play("Idle")
				if runSound.playing:
					runSound.stop()
			
	if velocity.y > 0.0: 
		if not AttackManager.is_attacking(): # || anim.current_animation != "Death" 
			if not isJumping and CoyoteTimer.is_stopped() and isPossibleCoyote: 
				CoyoteTimer.start()
			anim.play("Fall")
	
	#print(str(isJumping) + " " + str(not CoyoteTimer.is_stopped()))

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
			if Game.normalWorld:
				Game.take_damage(1, true)
	

func get_direction():
	if (get_node("Sprite2D").flip_h == true):
		return -1
	return 1

func _on_switch_world(normalWorld : bool):
	if (Game.isImmortal): return
	
	create_sound("Switch_world", self.global_transform.origin)
	if (normalWorld):
		Game.isDeathWorld = false
		set_collision_mask_value(2, true)
		set_collision_mask_value(4, true)
		set_collision_mask_value(5, false)
		set_collision_mask_value(7, false)
	if (not normalWorld):
		Game.isDeathWorld = true
		set_collision_mask_value(2, false)
		set_collision_mask_value(4, false)
		set_collision_mask_value(5, true)
		set_collision_mask_value(7, true)

func be_invincible(enemy : bool):
	#BUG: Sometimes the character is unable to lose any damage(Should be because of invinsible status)
	ScreenShakeTimer.start()
	if (Game.playerDead):
		anim.play("Death")
	elif (Game.isImmortal):
		if Game.playerHP > 2:
			await get_tree().create_timer(0.5).timeout
		Game.playerHP = 10
	elif (enemy):
		InvincibilityTimer.start()
		Game.isInvulnerable = true
	
func _on_invincibity_timer_timeout():
	Sprite.material.set_shader_parameter("time", 0)
	Game.isInvulnerable = false

func calculate_dash_direction() -> Vector2:
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	return Vector2(direction_x, direction_y).normalized()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "Death"):
		self.queue_free()
		get_tree().change_scene_to_file("res://scenes/areas/world.tscn")
		
func create_sound(sound_name, position=null):
	var audio_clone = audioPlayer.instantiate()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(audio_clone)
	audio_clone.play_sound(sound_name, position)
	
func _on_player_damage(enemy : bool):
	if (dying):
		return
		
	create_sound("Damage")
	if (Game.playerHP <= 5):
		if (!breathingSound.playing):
			breathingSound.play()
		if (!heartbeatSound.playing):
			heartbeatSound.play()
		heartbeatSound.volume_db = linear_to_db(1 - Game.playerHP/6);
	if (Game.playerHP <= 0):
		Utils.log_death()
		create_sound("Death")
		dying = true
		breathingSound.stop()
		heartbeatSound.stop()

func change_camera_limits(left_limit, top_limit, right_limit, bottom_limit):
	get_node("Camera2D").change_camera_limits(left_limit, top_limit, right_limit, bottom_limit)


func _input(event):
	if event.is_action_released("jump"):
		if velocity.y < 0.0:
			velocity.y *= 0.5


func _on_coyote_timer_timeout():
	isPossibleCoyote = false
