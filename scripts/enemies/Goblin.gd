extends CharacterBody2D

var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var normalAreaX
var attackAreaX
var personalSpace = 35
var normalRayCastX
var chase = false
var attacking = false
var dying = false

@export var health : int = 3
@export var knockbackSpeed = 0.4

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var DetectionArea = $DetectionArea
@onready var AttackDetectionArea = $AttackDetectionArea
@onready var AttackDetectionAreaShape = $AttackDetectionArea/CollisionShape2D
@onready var AttackArea = $AttackArea
@onready var AttackAreaShape = $AttackArea/CollisionShape2D
@onready var Collider = $Collider

@onready var AttackCooldown = $AttackCooldown

@onready var normalSprite = $Sprite2D
@onready var shadowSprite = $FlameAnimation
@onready var deathSound = $DeathSound
@onready var hitSound = $HitSound
@onready var attackSound = $AttackSound

func _ready():
	anim.play("Idle")
	normalAreaX = AttackDetectionAreaShape.position.x
	attackAreaX = AttackAreaShape.position.x
	normalRayCastX = $Direction.scale.x
	Events.switch_world.connect(_on_switch_world)


func _physics_process(delta):
	
	if anim.current_animation == "Hit":
		if sprite.flip_h == true:
			position.x += knockbackSpeed
		else:
			position.x -= knockbackSpeed
		return
		
	#Gravity
	velocity.y += gravity * delta
	
	if dying:
		return
		
	if chase:
		
		#player = get_node("../../Player/Player")
		var distance = (player.global_position - self.global_position)
		var direction = distance.normalized()
		if direction.x < 0:
			sprite.flip_h = true
			AttackAreaShape.rotation_degrees = 74.0
			AttackDetectionAreaShape.position.x = - normalAreaX
			AttackAreaShape.position.x = - attackAreaX
			$Direction.scale.x = -normalRayCastX
		else:
			sprite.flip_h = false
			AttackDetectionAreaShape.position.x = normalAreaX
			AttackAreaShape.rotation_degrees = 108.6
			AttackAreaShape.position.x = attackAreaX
			$Direction.scale.x = normalRayCastX
		
		if $Direction/RayCastFloor.is_colliding() && abs(distance.x) > personalSpace:
			anim.play("Run")
			velocity.x = direction.x * SPEED
		else:
			anim.play("Idle")
			velocity.x = 0
		
	elif attacking:
		if anim.current_animation != "Death" || anim.current_animation != "Hit":
			anim.play("Attack")
			if (!attackSound.is_playing()):
				attackSound.play()
			velocity.x = 0
			
	else:
		if anim.current_animation != "Death" || anim.current_animation != "Attack" || anim.current_animation != "Hit":
			anim.play("Idle")
		velocity.x = 0
	move_and_slide()
	

func death():
	health -= 1
	if (health > 0):
		hitSound.play()
		attackSound.stop()
		anim.play("Hit")
		return
	if !Game.isImmortal: Game.goblins_killed += 1
	dying = true
	chase = false
	attacking = false
	#Game.courage += 8 * (1 - (Game.playerHP / Game.maxHP)) + 2
	#Game.courage += 6 * (1 - (Game.playerHP / Game.maxHP)) + 4
	Game.set_courage(6 * (1 - (Game.playerHP / Game.maxHP)) + 4);
	print(Game.courage)
	Utils.saveGame()
	anim.play("Death")
	hitSound.stop()
	attackSound.stop()
	deathSound.play()
	self.velocity = Vector2(0,0)
	get_node("CollisionShape2D").queue_free()
	await anim.animation_finished
	self.queue_free()
	
	
func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		chase = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		chase = false
		

func _on_attack_detection_area_body_entered(body):
	print(attacking)
	if body.name == "Player" && AttackCooldown.is_stopped():
		attacking = true
		chase = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		attacking = false
		AttackCooldown.start()
		check_if_player_in_detection_range()


func check_if_player_in_detection_range():
	var bodies = DetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			chase = true
			break
			

func _on_attack_cooldown_timeout():
	var bodies = AttackDetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			attacking = true
			chase = false
			break

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		set_collision_mask_value(3, true)
		DetectionArea.set_collision_mask_value(3, true)
		AttackDetectionArea.set_collision_mask_value(3, true)
		Collider.set_collision_mask_value(3, true)
		AttackArea.set_collision_mask_value(3, true)
		normalSprite.visible = true
		shadowSprite.visible = false
	if (not normalWorld):
		set_collision_mask_value(3, false)
		DetectionArea.set_collision_mask_value(3, false)
		AttackDetectionArea.set_collision_mask_value(3, false)
		Collider.set_collision_mask_value(3, false)
		AttackArea.set_collision_mask_value(3, false)
		normalSprite.visible = false
		shadowSprite.visible = true
