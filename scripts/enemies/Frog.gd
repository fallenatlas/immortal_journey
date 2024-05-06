extends CharacterBody2D

var SPEED = 50
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false

@onready var playerDetection = get_node("PlayerDetection")
@onready var weakSpot = get_node("PlayerDeath")
@onready var killPlayer = get_node("PlayerCollision")

@onready var normalSprite = get_node("AnimatedSprite2D")
@onready var shadowSprite = get_node("Sprite2D")

func _ready():
	get_node("AnimatedSprite2D").play("Idle")
	Events.switch_world.connect(_on_switch_world)

func _physics_process(delta):
	#Gravity for frog
	velocity.y += gravity * delta
	if chase:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
		player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 3
		death()
		
func death():
	chase = false
	Game.courage += 5
	Utils.saveGame()
	get_node("AnimatedSprite2D").play("Death")
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		set_collision_mask_value(3, true)
		playerDetection.set_collision_mask_value(3, true)
		weakSpot.set_collision_mask_value(3, true)
		killPlayer.set_collision_mask_value(3, true)
		normalSprite.visible = true
		shadowSprite.visible = false
	if (not normalWorld):
		set_collision_mask_value(3, false)
		playerDetection.set_collision_mask_value(3, false)
		weakSpot.set_collision_mask_value(3, false)
		killPlayer.set_collision_mask_value(3, false)
		normalSprite.visible = false
		shadowSprite.visible = true
