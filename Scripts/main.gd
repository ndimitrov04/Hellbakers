extends Node2D

@onready var arena = $Arena
@onready var animation_player = $Overlay/AnimationPlayer

@onready var overlay = $GUI/Overlay

@onready var current_arena : int = -1

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
	else:
		win_game()

func reward_biscuits(amount):
	ShopData.biscuits += amount

func win_game():
	pass
