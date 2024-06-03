extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var FSM = $FSM

@onready var sprite = $Sprite2D
@onready var attackDetectionShape = $AttackDetectionArea/CollisionShape2D
@onready var jumpAttackDetectionShape = $JumpAttackDetectionArea/CollisionShape2D
@onready var magicProjectile = load("res://scenes/enemies/MagicProjectile.tscn")

@onready var attack3Timer = $Attack3Timer

@onready var hitColldown = $HitCooldown

@onready var hitSound = $HitSound
@onready var teleportSound = $TeleportSound2
@onready var bossMusic1 = $"BossMusic1"
@onready var bossMusic2 = $"BossMusic2"

@onready var healthBar = $CanvasLayer/TextureProgressBar

@export var teleportPos1 : Marker2D
@export var teleportPos2 : Marker2D
@export var teleportPos3 : Marker2D

var image1 = load("res://Health Bar Asset Pack 2 by Adwit Rahman/HealthBarProgress.png")
var image2 = load("res://Health Bar Asset Pack 2 by Adwit Rahman/HealthBarProgressGray.png")

var health = 15

var main
var player

var time = 0

var normalAreaX
var normalJumpAttackDetectionAreaX

var direction_index = 0
var attack3Couter = 0
var directions : PackedVector2Array


var can_update : bool = true :
	get:
		return can_update
	set(value):
		can_update = value
		get_node("FSM").can_update = value

@onready var attack2Sound = $Attack2Sound
@onready var jumpSound = $JumpSound
@onready var attack3Sound = $Attack3Sound

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
	
	
	Events.switch_world.connect(_on_switch_world)

func _physics_process(delta):
	if (bossMusic1.is_playing() && Game.isLastStand):
		Game.attack_buffer = get_node("../../Player/Player/AttackManager").max_attacks
		bossMusic1.stop()
		bossMusic2.play()
		
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
	if (!attack3Sound.is_playing()):
		attack3Sound.play()
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
	hitSound.play()
	if Game.isDeathWorld:
		health -= 1
		
	if (health > 0):
		hitSound.play()
		hitColldown.start()
		if not Game.isDeathWorld:
			Game.courage = min(Game.courage + 2 * (1 - (Game.playerHP / Game.maxHP)) + 3, Game.maxCourage)
		return
	bossMusic1.stop()
	bossMusic2.stop()
	FSM.force_change_state("Final")



func _on_hit_cooldown_timeout():
	sprite.material.set_shader_parameter("time", 0.0)
	
func play_remove_immortality_animation():
	get_node("AnimationPlayer").play("Attack2")
	attack2Sound.play()
	
func play_jump_animation():
	get_node("AnimationPlayer").play("JumpAttack")
	jumpSound.play()
	
func play_idle_animation():
	get_node("AnimationPlayer").play("Idle")
	
func play_disappear_animation():
	get_node("AnimationPlayer").play("TutorialAnimation")
	teleportSound.play()


func _on_switch_world(normalWorld : bool):
	if (normalWorld):
		set_collision_mask_value(7, false)
		healthBar.set_progress_texture(image2)
	if (not normalWorld):
		set_collision_mask_value(7, true)
		healthBar.set_progress_texture(image1)
