extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var attackDetectionShape = $AttackDetectionArea/CollisionShape2D
@onready var jumpAttackDetectionShape = $JumpAttackDetectionArea/CollisionShape2D
@onready var magicProjectile = load("res://scenes/enemies/MagicProjectile.tscn")

@onready var attack3Timer = $Attack3Timer

@onready var hitColldown = $HitCooldown

@onready var hitSound = $HitSound
@onready var attackSound = $AttackSound

var health = 100

var main
var player

var time = 0

var normalAreaX
var normalJumpAttackDetectionAreaX

var direction_index = 0
var attack3Couter = 0
var directions : PackedVector2Array

func _ready():
	main = $"../.."
	player = get_node("../../Player/Player")
	
	normalAreaX = attackDetectionShape.position.x
	normalJumpAttackDetectionAreaX = jumpAttackDetectionShape.position.x
	
	#Attack3 directions
	directions.append(Vector2(1, 0))
	directions.append(Vector2(1, -1))
	directions.append(Vector2(0, -1))
	directions.append(Vector2(-1, -1))
	directions.append(Vector2(-1, 0))
	directions.append(Vector2(-1, 1))
	directions.append(Vector2(0, 1))
	directions.append(Vector2(1, 1))

func _physics_process(delta):
	
	time += delta * 2
	if(time > 1):
		time = 0
			
	if !hitColldown.is_stopped():
		sprite.material.set_shader_parameter("time", time)
	
	var direction = (player.position - self.position)
	#For some reason, it's not 0
	if direction.x < -10:
		sprite.flip_h = true
		attackDetectionShape.position.x = - normalAreaX
		jumpAttackDetectionShape.position.x = - normalJumpAttackDetectionAreaX
	else:
		sprite.flip_h = false
		attackDetectionShape.position.x = normalAreaX
		jumpAttackDetectionShape.position.x = normalJumpAttackDetectionAreaX
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func shoot():
	var instance = magicProjectile.instantiate()
	var playerPos = get_node("../../Player/Player").global_position
	instance.direction = Vector2(playerPos.x, playerPos.y + 5) - global_position
	
	#Right
	if(sprite.flip_h == false):
		instance.spawnPosition = Vector2(global_position.x + 15, global_position.y - 8)
	#Left
	else:
		instance.spawnPosition = Vector2(global_position.x - 15, global_position.y - 8)
	
	main.add_child.call_deferred(instance)
	
func shoot_2():

	var instance = magicProjectile.instantiate()
	instance.direction = directions[direction_index]
	#print(instance.direction)
	instance.spawnPosition = global_position
	
	main.add_child.call_deferred(instance)
	attack3Timer.start()


func _on_attack_3_timer_timeout():
	direction_index += 1
	if(direction_index > 7 or direction_index < 0):
		direction_index = 0
		attack3Couter += 1
		if attack3Couter > 1:
			attack3Couter = 0
			return
	shoot_2()


func death():
	health -= 1
	if (health > 0):
		hitSound.play()
		hitColldown.start()
		Game.courage = min(Game.courage + 2 * (1 - (Game.playerHP / Game.maxHP)) + 4, Game.maxCourage)
		return
	Utils.saveGame()
	
	#Die?


func _on_hit_cooldown_timeout():
	sprite.material.set_shader_parameter("time", 0.0)
