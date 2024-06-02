extends State
class_name DragonExplodeState


@onready var body = $"../.."

@onready var anim = $"../../AnimationPlayer"
@onready var hitSound = $"../../HitSound"

func Enter():
	anim.play("Explode")
	hitSound.play()
	
func Update(delta: float):
	
	body.velocity = Vector2(0, 0)
	
func Exit():
	body.queue_free()

