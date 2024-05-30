extends CharacterBody2D

var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var normalAreaX
var personalSpace = 0.4
var normalRayCastX
var chase = false
var attacking = false
var dying = false

@export var health : int = 3
@export var knockbackSpeed = 1

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var DetectionArea = $DetectionArea
@onready var AttackDetectionArea = $AttackDetectionArea
@onready var AttackDetectionAreaShape = $AttackDetectionArea/CollisionShape2D
@onready var AttackArea = $AttackArea
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
		
		if anim.current_animation != "Death" || anim.current_animation != "Attack" || anim.current_animation != "Hit":
			anim.play("Run")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x < 0:
			sprite.flip_h = true
			AttackDetectionAreaShape.position.x = - normalAreaX
			$Direction.scale.x = -normalRayCastX
		else:
			sprite.flip_h = false
			AttackDetectionAreaShape.position.x = normalAreaX
			$Direction.scale.x = normalRayCastX
		
		if $Direction/RayCastFloor.is_colliding() && abs(direction.x) > personalSpace:
			velocity.x = direction.x * SPEED
		else:
			anim.play("Idle")
			velocity.x = 0
		
	elif attacking:
		if anim.current_animation != "Death" || anim.current_animation != "Hit":
			anim.play("Attack")
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
		anim.play("Hit")
		return
	dying = true
	chase = false
	attacking = false
	#Game.courage += 8 * (1 - (Game.playerHP / Game.maxHP)) + 2
	#Game.courage += 6 * (1 - (Game.playerHP / Game.maxHP)) + 4
	Game.set_courage(6 * (1 - (Game.playerHP / Game.maxHP)) + 4);
	print(Game.courage)
	Utils.saveGame()
	anim.play("Death")
	deathSound.play()
	self.velocity = Vector2(0,0)
	get_node("CollisionShape2D").queue_free()
	await anim.animation_finished
	self.queue_free()
	
	
func _on_detection_area_body_entered(body):
	if body.name == "Player":
		chase = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		chase = false
		

func _on_attack_detection_area_body_entered(body):
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
