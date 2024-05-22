extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite = $Sprite2D
@onready var attackDetectionShape = $AttackDetectionArea/CollisionShape2D
@onready var magicProjectile = load("res://scenes/enemies/MagicProjectile.tscn")

var main
var player

var normalAreaX

func _ready():
	main = $"../.."
	player = get_node("../../Player/Player")
	
	normalAreaX = attackDetectionShape.position.x

func _physics_process(delta):
	
	var direction = (player.position - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		attackDetectionShape.position.x = - normalAreaX
	else:
		sprite.flip_h = false
		attackDetectionShape.position.x = normalAreaX
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func shoot():
	var instance = magicProjectile.instantiate()
	var playerPos = get_node("../../Player/Player").global_position
	instance.direction = Vector2(playerPos.x, playerPos.y + 10) - global_position
	
	#Right
	if(sprite.flip_h == false):
		instance.spawnPosition = Vector2(global_position.x + 15, global_position.y - 8)
	#Left
	else:
		instance.spawnPosition = Vector2(global_position.x - 15, global_position.y - 8)
	
	main.add_child.call_deferred(instance)
