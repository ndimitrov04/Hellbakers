extends Node2D

@onready var arena = $Arena
@onready var animation_player = $Overlay/AnimationPlayer

@onready var control = $GUI/Control

@onready var overlay = $GUI/Overlay

@onready var current_arena : int = -1

@onready var credits = $Credits

@onready var ARENA_0 = preload("res://Scenes/Arenas/arena_0.tscn")
@onready var ARENA_1 = preload("res://Scenes/Arenas/arena_1.tscn")
@onready var ARENA_2 = preload("res://Scenes/Arenas/arena_2.tscn")
@onready var ARENA_3 = preload("res://Scenes/Arenas/arena_3.tscn")
@onready var ARENA_4 = preload("res://Scenes/Arenas/arena_4.tscn")
@onready var ARENA_5 = preload("res://Scenes/Arenas/arena_5.tscn")
@onready var ARENA_6 = preload("res://Scenes/Arenas/arena_6.tscn")
@onready var ARENA_7 = preload("res://Scenes/Arenas/arena_7.tscn")
@onready var ARENA_8 = preload("res://Scenes/Arenas/arena_8.tscn")
@onready var ARENA_9 = preload("res://Scenes/Arenas/arena_9.tscn")
@onready var ARENA_10 = preload("res://Scenes/Arenas/arena_10.tscn")
@onready var ARENA_11 = preload("res://Scenes/Arenas/arena_11.tscn")
@onready var ARENA_12 = preload("res://Scenes/Arenas/arena_12.tscn")
@onready var ARENA_13 = preload("res://Scenes/Arenas/arena_13.tscn")
@onready var ARENA_14 = preload("res://Scenes/Arenas/arena_14.tscn")
@onready var ARENA_15 = preload("res://Scenes/Arenas/arena_15.tscn")
@onready var ARENA_16 = preload("res://Scenes/Arenas/arena_16.tscn")
@onready var ARENA_17 = preload("res://Scenes/Arenas/arena_17.tscn")
@onready var ARENA_18 = preload("res://Scenes/Arenas/arena_18.tscn")
@onready var ARENA_19 = preload("res://Scenes/Arenas/arena_19.tscn")
@onready var ARENA_20 = preload("res://Scenes/Arenas/arena_20.tscn")
@onready var ARENA_21 = preload("res://Scenes/Arenas/arena_21.tscn")
@onready var ARENA_22 = preload("res://Scenes/Arenas/arena_22.tscn")
@onready var ARENA_23 = preload("res://Scenes/Arenas/arena_23.tscn")
@onready var ARENA_24 = preload("res://Scenes/Arenas/arena_24.tscn")
@onready var ARENA_25 = preload("res://Scenes/Arenas/arena_25.tscn")
@onready var ARENA_26 = preload("res://Scenes/Arenas/arena_26.tscn")
@onready var ARENA_27 = preload("res://Scenes/Arenas/arena_27.tscn")
@onready var ARENA_28 = preload("res://Scenes/Arenas/arena_28.tscn")
@onready var ARENA_29 = preload("res://Scenes/Arenas/arena_29.tscn")


var arenas : Array

var ovenlord_speech = [
	"Well well well, what do we have here, a brand new cook! Burn all of the challenges which I've lovingly baked for you and you might get to live at the end of this.",
	"Like candy? So do I. Have some candy skeletons. They're way tastier and way smarter than my cooks. Oh sorry - that would also you, of course.",
	"Time for more coo- Why are there cats in my kitchen? What do you mean 'they walked through the walls' ???",
	"Mmm, you seem to be holding on well. How about some ranged combat to *spice* things up? Haha. Get it? Spice? Because I'm a-",
	"Do you think it'd look more evil if I twirled my moustache clockwise or counterclockwise?",
	"Wow, I seem to have some thirsty employees today. What kind of chef wouldn't let his cooks have a break and a drink from your HP?",
	"WHO DID THIS? THESE GUYS ARE SO UNBAKED THEY'RE STILL DOUGH! ... Actually that's pretty good, raw dough can't really take much damage.",
	"Did you know that you can make a killer cake with walnuts, 8 eggs, 220g of powdered sugar and chocolate? It's actually a really nice cake. Here's the recipe:",
	"A good cook should be able to work under pressure! And also under heavy fire from the LONG RANGE BOWS of the undead. ENJOY!",
	"It's chef longteeth! It's actually really funny why they call him that - you see...",
	"What a scrambled situation. Maybe try scrambling your units? I'll eat some unscrambled (patent pending) eggs in the meantime.",
	"In any kitchen, there should be a constant source of heat. Ovens are insufficient for a master such as I. This is why I have replaced them with explosives.",
	"Left chocolate dessert (not sponsored, not affiliated) or right chocolate dessert (not sponsored, not affiliated)?",
	"To whoever keeps making these underbaked dough guys - I will literally extract and cook your soul.",
	"Please stop destroying my candy skeletons. Have you got any clue how much effort making ONE of them takes?",
	"Is it me or is it getting kind of really hot in here? ... Bombs? Naaaah. It's probably the thermostat, it's broke like 2 montsh ago.",
	"Pro tip: Keeping carnivores in your walk in meat freezer is NOT unhygenic. That is a fact.",
	"Deja vu?",
	"For the time you've been here you've cooked exactly 0 meals and have destroyed around 60 of my employees. I'm cutting your pay.",
	"Yes, I know that I don't pay you anything. Your salary will now be -25$. You will be paying me to be here. No, you cannot leave.",
	"You butter believe it, I’m a great cook!",
	"Let's taco about how cooked you will be by the end <3",
	"Try not to crumble under the pressure.",
	"Did you like my cooking puns? Weren't they just GRATE?",
	"You thought the oven was just endless torture? Nah, it's just me here. And these 350295 monsters. And my 29521+e puns. <3",
	"I'm getting quite bored. Time to turn up the heat. Haha get it? PUNS ARE FUNNY. DIE!",
	"This enemy lineup makes my left eyebrow excited.",
	"I'm out of puns.",
	"Wow you've really gotten far. I'm calling backup.",
	"Haha, I was just kidding about cooking you alive, it was just puns and stuff - (please kill this guy, I'm like two rooms over)",
	"I am cooked. BUT SO ARE YOU! PREPARE FOR THE FINAL BATTLE!"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.first_run:
		Globals.first_run = false
		overlay.show()
	arenas = [
		ARENA_0, ARENA_1, ARENA_2, ARENA_3,
		ARENA_4, ARENA_5, ARENA_6, ARENA_7,
		ARENA_8, ARENA_9, ARENA_10, ARENA_11,
		ARENA_12, ARENA_13, ARENA_14, ARENA_15,
		ARENA_16, ARENA_17, ARENA_18, ARENA_19,
		ARENA_20, ARENA_21, ARENA_22, ARENA_23,
		ARENA_24, ARENA_25, ARENA_26, ARENA_27,
		ARENA_28, ARENA_29
	]
	load_next_arena()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug_next_level"):
		load_next_arena()
	if Input.is_action_just_pressed("debug_biscuit"):
		ShopData.biscuits += 15

func load_next_arena():
	if current_arena + 1 < arenas.size():
		arena.queue_free()
		current_arena += 1
		var arena_instance = arenas[current_arena].instantiate()
		add_child(arena_instance)
		control.speak.text = ovenlord_speech[current_arena]
	else:
		win_game()

func reward_biscuits(amount):
	ShopData.biscuits += amount

func win_game():
	credits.show()
