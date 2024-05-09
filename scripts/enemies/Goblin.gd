extends CharacterBody2D

var SPEED = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var normalAreaX
var chase = false
var attacking = false

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

func _ready():
	anim.play("Idle")
	normalAreaX = AttackDetectionAreaShape.position.x
	Events.switch_world.connect(_on_switch_world)


func _physics_process(delta):
	#Gravity for frog
	velocity.y += gravity * delta
	if chase:
		
		if anim.current_animation != "Death" || anim.current_animation != "Attack":
			anim.play("Run")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x < 0:
			sprite.flip_h = true
			AttackDetectionAreaShape.position.x = - normalAreaX
		else:
			sprite.flip_h = false
			AttackDetectionAreaShape.position.x = normalAreaX
			
		velocity.x = direction.x * SPEED
		
	elif attacking:
		if anim.current_animation != "Death":
			anim.play("Attack")
			velocity.x = 0
			
	else:
		if anim.current_animation != "Death" || anim.current_animation != "Attack":
			anim.play("Idle")
		velocity.x = 0
	move_and_slide()
	

func death():
	chase = false
	attacking = false
	Game.courage += 5
	Utils.saveGame()
	anim.play("Death")
	await get_node("AnimatedSprite2D").animation_finished
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
			

func _on_attack_cooldown_timeout():
	var bodies = AttackDetectionArea.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			attacking = true
			chase = false

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
