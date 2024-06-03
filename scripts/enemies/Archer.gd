extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var health : int = 2
@export var knockbackSpeed = 0.4

var attacking = false
var dying = false

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var AttackDetectionArea = $AttackDetectionArea

@onready var AttackCooldown = $AttackCooldown

@onready var normalSprite = $Sprite2D
@onready var shadowSprite = $FlameAnimation

@onready var deathSound = $DeathSound
@onready var hitSound = $HitSound
@onready var attackSound = $AttackSound

var main
var original_offset
var offset_left
var offset_right

@onready var arrow = load("res://scenes/enemies/Arrow.tscn")

var player

func _ready():
	anim.play("Idle")
	Events.switch_world.connect(_on_switch_world)
	main = $"../.."
	player = get_node("../../Player/Player")
	original_offset = sprite.offset.x
	offset_left = original_offset - 25
	offset_right = original_offset + 25


func _physics_process(delta):
	if anim.current_animation == "Hit":
		if sprite.flip_h == true:
			position.x += knockbackSpeed
		else:
			position.x -= knockbackSpeed
		sprite.offset.x = original_offset
		return
	#Gravity for frog
	velocity.y += gravity * delta
	if dying:
		return
	elif attacking:
		if anim.current_animation != "Death" || anim.current_animation != "Hit":
			anim.play("Attack")
			velocity.x = 0
	else:
		if anim.current_animation != "Death" || anim.current_animation != "Attack" || anim.current_animation != "Hit":
			anim.play("Idle")
		velocity.x = 0
		
	var direction = (player.position - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		
	#Fix for attack sprite
	if anim.current_animation == "Attack" && sprite.flip_h == false:
		sprite.offset = Vector2(offset_right, 0)
	elif anim.current_animation == "Attack" && sprite.flip_h == true:
		sprite.offset = Vector2(offset_left, 0)
	else:
		sprite.offset.x = original_offset
		
	move_and_slide()


func death():
	health -= 1
	if (health > 0):
		hitSound.play()
		attackSound.stop()
		anim.play("Hit")
		return
	if !Game.isImmortal: Game.archers_killed += 1
	sprite.offset.x = original_offset
	dying = true
	attacking = false
	#Game.courage += 8 * (1 - (Game.playerHP / Game.maxHP)) + 2
	Game.set_courage(6 * (1 - (Game.playerHP / Game.maxHP)) + 4);
	Utils.saveGame()
	anim.play("Death")
	deathSound.play()
	hitSound.stop()
	attackSound.stop()
	self.velocity = Vector2(0,0)
	get_node("CollisionShape2D").queue_free()
	await anim.animation_finished
	self.queue_free()


func _on_attack_detection_area_body_entered(body):
	if body.name == "Player" && AttackCooldown.is_stopped():
		if (!attackSound.is_playing()):
			attackSound.play()
		attacking = true
		

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		attacking = false
		AttackCooldown.start()
		#Send projectile
		shoot()


func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		set_collision_mask_value(3, true)
		AttackDetectionArea.set_collision_mask_value(3, true)
		normalSprite.visible = true
		shadowSprite.visible = false
	if (not normalWorld):
		set_collision_mask_value(3, false)
		AttackDetectionArea.set_collision_mask_value(3, false)
		normalSprite.visible = false
		shadowSprite.visible = true


func _on_attack_cooldown_timeout():
	var bodies = AttackDetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" && !dying:
			attackSound.play()
			attacking = true


func shoot():
	var instance = arrow.instantiate()
	var playerPos = get_node("../../Player/Player").global_position
	instance.direction = Vector2(playerPos.x, playerPos.y + 10) - global_position
	
	#Right
	if(sprite.flip_h == false):
		instance.spawnPosition = Vector2(global_position.x + 15, global_position.y - 8)
	#Left
	else:
		instance.spawnPosition = Vector2(global_position.x - 15, global_position.y - 8)
	
	main.add_child.call_deferred(instance)
