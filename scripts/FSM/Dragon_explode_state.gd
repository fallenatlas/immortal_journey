extends State
class_name DragonExplodeState


@onready var body = $"../.."

@onready var anim = $"../../AnimationPlayer"

func Enter():
	anim.play("Explode")
	
func Update(delta: float):
	
	body.velocity = Vector2(0, 0)
	
func Exit():
	body.queue_free()

