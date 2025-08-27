extends Panel

@onready var h_box_container = $HBoxContainer

@onready var card_scene = preload("res://Scenes/Cards/card.tscn")

@onready var placeholder_texture

## Each card contains its respective monster [0], texture [1], curse [2]
# This array must be updated to include all monsters and cards.
# This array must be assigned a value in the _ready() function.
var good_cards : Array

## Each card contains its respective monster [0], texture [1], curse [2]
# This array must be updated to include all monsters and cards.
# This array must be assigned a value in the _ready() function.
var bad_cards : Array

## This button group keeps track of which card is selected
## and forces only 1 card to be selectable at a time
var card_button_group = ButtonGroup.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	placeholder_texture = PlaceholderTexture2D.new()
	placeholder_texture.size = Vector2(96/2,144/2)
	
	good_cards = [
		[preload("res://Scenes/Monsters/zombie.tscn"), preload("res://Images/Sprites/Zombie/card.png"), false],
		[preload("res://Scenes/Monsters/crawler.tscn"), preload("res://Images/Sprites/Crawler/card.png"), false],
		[preload("res://Scenes/Monsters/skeleton.tscn"), placeholder_texture, false],
		[preload("res://Scenes/Monsters/stone_golem.tscn"), preload("res://Images/Sprites/StoneGolem/card.png"), false],
		[preload("res://Scenes/Monsters/goblin.tscn"), preload("res://Images/Sprites/Goblin/card.png"), false],
		[preload("res://Scenes/Monsters/vampire.tscn"), placeholder_texture, false]
	]

	bad_cards = [
		[preload("res://Scenes/Monsters/zombie.tscn"), preload("res://Images/Sprites/Zombie/card.png"), true],
		[preload("res://Scenes/Monsters/crawler.tscn"), preload("res://Images/Sprites/Crawler/card.png"), true],
		[preload("res://Scenes/Monsters/skeleton.tscn"), placeholder_texture, true],
		[preload("res://Scenes/Monsters/stone_golem.tscn"), preload("res://Images/Sprites/StoneGolem/card.png"), true],
		[preload("res://Scenes/Monsters/goblin.tscn"), preload("res://Images/Sprites/Goblin/card.png"), true],
		[preload("res://Scenes/Monsters/vampire.tscn"), placeholder_texture, true]
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug_take_card"):
		add_card(generate_random_card(25000))

## Add card to hand and add card button to hand button_group
## so only one card can be "active" or "chosen" at a time
func add_card(card):
	if h_box_container.get_child_count() >= 8:
		print("Hand is full!")
		return
	var card_instance = card_scene.instantiate()
	card_instance.button_group = card_button_group
	card_instance.monster = card[0]
	card_instance.card_sprite = card[1]
	card_instance.texture_normal = card[1]
	card_instance.texture_pressed = card[1]
	h_box_container.add_child(card_instance)
	card_instance.cursed = card[2]
	if card_instance.cursed:
		card_instance.modulate = Color(1,0.6,0.6)
	
func generate_random_card(soul_dough : int) -> Array:
	var bad_card_chance : float = 50.0 / (75 + soul_dough)
	var generate_bad_card : bool = randf() < bad_card_chance
	
	if generate_bad_card:
		print("BAD CARD GENERATED >:(")
		return bad_cards.pick_random()
	
	return good_cards.pick_random()

## Check if hand contains cards that must be played
## Returns: 
## False if hand contains cards that must be played,
## True otherwise
func validate() -> bool:
	for card in h_box_container.get_children():
		if card.cursed:
			return false
	return true
