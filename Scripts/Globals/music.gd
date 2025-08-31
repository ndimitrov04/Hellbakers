extends AudioStreamPlayer

@onready var mouse = $Mouse

@onready var BATTLE_THEME_1 = preload("res://Audio/Music/Battle theme 1 (complete).wav")
@onready var BATTLE_THEME_2 = preload("res://Audio/Music/Battle theme 2 (complete).wav")
@onready var BATTLE_THEME_3 = preload("res://Audio/Music/Battle theme 3 (complete).wav")
@onready var BATTLE_THEME_4 = preload("res://Audio/Music/Battle theme 4 (complete).wav")
@onready var STRATEGY_THEME = preload("res://Audio/Music/Strategy theme (complete).wav")

@onready var SHOP_THEME = preload("res://Audio/Music/shop.wav")
@onready var TITLE_THEME = preload("res://Audio/Music/title.wav")

@onready var battle_themes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	battle_themes = [
		BATTLE_THEME_1,
		BATTLE_THEME_2,
		BATTLE_THEME_3,
		BATTLE_THEME_4
	]
	connect("finished", _on_song_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("LMB"):
		mouse.play()

func _on_song_finished():
	if stream == TITLE_THEME:
		play()
		return
	elif stream == SHOP_THEME:
		play()
		return
	elif stream == STRATEGY_THEME:
		play()
		return
	else:
		stream = battle_themes.pick_random()
		play()
		return
