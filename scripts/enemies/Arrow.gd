extends CharacterBody2D

@export var SPEED = 200

var direction : Vector2
var spawnPosition : Vector2
@onready var sprite = $Sprite2D
@onready var coll = $CollisionShape2D
@onready var despawnTimer = $DespawnTimer
@onready var arrowHitbox = $MagicHitbox

func _ready():
	global_position = spawnPosition
	sprite.rotation = atan2(direction.y, direction.x)
	coll.rotation = atan2(direction.y, direction.x)
	despawnTimer.start()
	
func _physics_process(delta):
	
	if Game.isDeathWorld == false:
		set_collision_mask_value(3, true)
		arrowHitbox.set_collision_mask_value(3, true)
		sprite.material.set_shader_parameter("isOtherWorld", 0.0)
		
	elif Game.isDeathWorld == true:
		set_collision_mask_value(3, false)
		arrowHitbox.set_collision_mask_value(3, false)
		sprite.material.set_shader_parameter("isOtherWorld", 1.0)
		
	velocity = direction.normalized() * SPEED
	move_and_slide()


func _on_magic_hitbox_body_entered(body):
	if body.name == "Player":
		Game.take_damage(2, true)
		queue_free()


func _on_despawn_timer_timeout():
	queue_free()



