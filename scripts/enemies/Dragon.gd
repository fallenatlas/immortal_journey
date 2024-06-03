extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var attackDetectionShape = $DetectionArea/CollisionShape2D

@onready var DetectionArea = $DetectionArea
@onready var AttackDetectionArea = $AttackDetectionArea
@onready var AttackDetectionAreaShape = $AttackDetectionArea/CollisionShape2D
@onready var AttackArea = $AttackArea
@onready var Collider = $Collider
@onready var normalSprite = $Sprite2D
@onready var shadowSprite = $FlameAnimation

@onready var moveSound = $MoveSound
@onready var hitSound = $HitSound
@onready var attackSound = $AttackSound

@onready var FSM = $FSM


var health = 1

var main
var player

var normalAreaX
var normalAttackDetectionAreaX


func _ready():
	main = $"../.."
	player = get_node("../../Player/Player")
	
	normalAreaX = attackDetectionShape.position.x
	normalAttackDetectionAreaX = attackDetectionShape.position.x
	Events.switch_world.connect(_on_switch_world)
	

func _physics_process(delta):
	
	if velocity.x < 0:
		sprite.flip_h = true
		attackDetectionShape.position.x = - normalAreaX
	else:
		sprite.flip_h = false
		attackDetectionShape.position.x = normalAreaX
		
	if (!moveSound.is_playing() && FSM.current_state == $FSM/Idle):
		moveSound.play()
	
	if (FSM.current_state != $FSM/Idle):
		moveSound.stop()
	
	move_and_slide()


func death():
	health -= 1
	if (health > 0):
		#anim.play("Explode")
		return
	FSM.force_change_state("Explode")
	Game.courage = min(Game.courage + 6 * (1 - (Game.playerHP / Game.maxHP)) + 4, Game.maxCourage)
	Utils.saveGame()
	self.velocity = Vector2(0,0)
	get_node("CollisionShape2D").queue_free()
	#await anim.animation_finished
	#self.queue_free()

func explode():
	health -= 1
	hitSound.play()
	Utils.saveGame()
	self.velocity = Vector2(0,0)
	get_node("CollisionShape2D").queue_free()
	self.queue_free()

func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		set_collision_mask_value(3, true)
		DetectionArea.set_collision_mask_value(3, true)
		Collider.set_collision_mask_value(3, true)
		AttackArea.set_collision_mask_value(3, true)
		normalSprite.visible = true
		shadowSprite.visible = false
	if (not normalWorld):
		set_collision_mask_value(3, false)
		DetectionArea.set_collision_mask_value(3, false)
		Collider.set_collision_mask_value(3, false)
		AttackArea.set_collision_mask_value(3, false)
		normalSprite.visible = false
		shadowSprite.visible = true
