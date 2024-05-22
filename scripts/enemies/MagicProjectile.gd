extends CharacterBody2D

@export var SPEED = 300

var direction : Vector2
var spawnPosition : Vector2
@onready var sprite = $Sprite2D
@onready var coll = $CollisionShape2D
@onready var despawnTimer = $DespawnTimer
@onready var magicHitbox = $MagicHitbox

func _ready():
	global_position = spawnPosition
	sprite.rotation = atan2(direction.y, direction.x)
	coll.rotation = atan2(direction.y, direction.x)
	despawnTimer.start()
	
func _physics_process(delta):
	
	velocity = direction.normalized() * SPEED
	rotation -= delta * 3
	move_and_slide()


func _on_magic_hitbox_body_entered(body):
	if body.name == "Player":
		Game.take_damage(2, true)
		queue_free()


func _on_despawn_timer_timeout():
	queue_free()



