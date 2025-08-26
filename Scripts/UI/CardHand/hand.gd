extends Panel

@onready var h_box_container = $HBoxContainer

@onready var card_scene = preload("res://Scenes/Cards/card.tscn")

@onready var placeholder_texture

## Each card contains its respective monster [0] and texture [1]
# This array must be updated to include all monsters and cards.
# This array must be assigned a value in the _ready() function.
var cards : Array

## This button group keeps track of which card is selected
## and forces only 1 card to be selectable at a time
var card_button_group = ButtonGroup.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	placeholder_texture = PlaceholderTexture2D.new()
	placeholder_texture.size = Vector2(96/2,144/2)
	
	cards = [
		[preload("res://Scenes/Monsters/zombie.tscn"), preload("res://Images/Sprites/Zombie/card.png")],
		[preload("res://Scenes/Monsters/crawler.tscn"), preload("res://Images/Sprites/Crawler/card.png")],
		[preload("res://Scenes/Monsters/skeleton.tscn"), placeholder_texture]
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug_take_card"):
		add_card(generate_random_card())

## Add card to hand and add card button to hand button_group
## so only one card can be "active" or "chosen" at a time
func add_card(card):
	if h_box_container.get_child_count() >= 8:
		print("Hand is full!")
		return
	var card_instance = card_scene.instantiate()
	card_instance.button_group = card_button_group
	card_instance.monster = card[0]
	card_instance.texture_normal = card[1]
	card_instance.texture_pressed = card[1]
	h_box_container.add_child(card_instance)
	
func generate_random_card():
	return cards.pick_random()
