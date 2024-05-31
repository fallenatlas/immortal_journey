extends Control

@onready var Flower1 = preload("res://assets/Flowers/Flowers_Separated/Flowers_With_Ouline/OrchidOUTLINED.png")
@onready var Flower2 = preload("res://assets/Flowers/Flowers_Separated/Flowers_With_Ouline/RoseOUTLINED.png")
@onready var Flower3 = preload("res://assets/Flowers/Flowers_Separated/Flowers_With_Ouline/PansyOUTLINED.png")
@onready var Flower4 = preload("res://assets/Flowers/Flowers_Separated/Flowers_With_Ouline/PoppyOUTLINED.png")
@onready var Flower5 = preload("res://assets/Flowers/Flowers_Separated/Flowers_With_Ouline/LilyOUTLINED.png")
@onready var Flower6 = preload("res://assets/Flowers/Flowers_Separated/Flowers_With_Ouline/TulipOUTLINED.png")
@onready var Flower7 = preload("res://assets/Flowers/Flowers_Separated/Flowers_With_Ouline/DaffodilOUTLINED.png")
@onready var Lock = preload("res://assets/Menu/lock.png")

@onready var Image1 = get_node("MarginContainer/VBoxContainer/GridContainer/Image1")
@onready var Image2 = get_node("MarginContainer/VBoxContainer/GridContainer/Image2")
@onready var Image3 = get_node("MarginContainer/VBoxContainer/GridContainer/Image3")
@onready var Image4 = get_node("MarginContainer/VBoxContainer/GridContainer/Image4")
@onready var Image5 = get_node("MarginContainer/VBoxContainer/GridContainer/Image5")
@onready var Image6 = get_node("MarginContainer/VBoxContainer/GridContainer/Image6")
@onready var Image7 = get_node("MarginContainer/VBoxContainer/GridContainer/Image7")

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.unlock_upgrade.connect(_unlock_upgrade)
	reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset():
	Image1.texture = Lock
	Image2.texture = Lock
	Image3.texture = Lock
	Image4.texture = Lock
	Image5.texture = Lock
	Image6.texture = Lock
	Image7.texture = Lock
	
func _unlock_upgrade(number):
	match number:
		1:
			Image1.texture = Flower1
		2:
			Image2.texture = Flower2
		3:
			Image3.texture = Flower3
		4:
			Image4.texture = Flower4
		5:
			Image5.texture = Flower5
		6:
			Image6.texture = Flower6
		7:
			Image7.texture = Flower7
