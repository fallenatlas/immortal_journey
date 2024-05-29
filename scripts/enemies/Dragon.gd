extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var attackDetectionShape = $DetectionArea/CollisionShape2D

@onready var deathSound = $DeathSound
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
	

func _physics_process(delta):
	
	
	if velocity.x < 0:
		sprite.flip_h = true
		attackDetectionShape.position.x = - normalAreaX
	else:
		sprite.flip_h = false
		attackDetectionShape.position.x = normalAreaX

	move_and_slide()


func death():
	health -= 1
	if (health > 0):
		hitSound.play()
		#anim.play("Explode")
		return
	#Game.courage += 8 * (1 - (Game.playerHP / Game.maxHP)) + 2
	#Game.courage += 6 * (1 - (Game.playerHP / Game.maxHP)) + 4
	FSM.force_change_state("Explode")
	Game.courage = min(Game.courage + 6 * (1 - (Game.playerHP / Game.maxHP)) + 4, Game.maxCourage)
	Utils.saveGame()
	deathSound.play()
	self.velocity = Vector2(0,0)
	get_node("CollisionShape2D").queue_free()
	#await anim.animation_finished
	#self.queue_free()



func explode():
	health -= 1
	if (health > 0):
		hitSound.play()
		#anim.play("Explode")
		return
	Utils.saveGame()
	deathSound.play()
	self.velocity = Vector2(0,0)
	get_node("CollisionShape2D").queue_free()
	#await anim.animation_finished
	self.queue_free()