extends CanvasLayer

var file = "res://Dialogues/dialogue_text.json"
var json_as_text = FileAccess.get_file_as_string(file)
var dialogue = JSON.parse_string(json_as_text)

@onready var Name = $Name
@onready var Chat = $Chat
@onready var timer = $Timer
@onready var audio_player = $AudioStreamPlayer

var current_dialogue_id = 0
var d_active = false

var current_npc = null


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

	
func start(NPC_name):
	Game.playerCanMove = false
	if d_active:
		return
	d_active = true
	self.visible = true
	
	current_dialogue_id = -1
	current_npc = NPC_name
	next_script()

func _input(event):
	if not d_active:
		return
		

	if event.is_action_pressed("interact"):
		audio_player.play()
		next_script()
			
			
func next_script():
	current_dialogue_id += 1
	
	if current_dialogue_id >= len(dialogue[current_npc]):
		timer.start()
		self.visible = false
		Game.playerCanMove = true
		
		return
		
	Name.text = current_npc
	if current_npc == "DeathEnd":
		Name.text = "Death"
	Chat.text = dialogue[current_npc][current_dialogue_id]


func _on_timer_timeout():
	d_active = false
	Game.playerCanMove = true
	Events.cutscene_finished.emit()
