extends Node2D

@onready var arena = $Arena
@onready var animation_player = $Overlay/AnimationPlayer

@onready var overlay = $GUI/Overlay

@onready var current_arena : int = -1

@onready var ARENA_0 = preload("res://Scenes/Arenas/arena_0.tscn")
@onready var ARENA_1 = preload("res://Scenes/Arenas/arena_1.tscn")
@onready var ARENA_2 = preload("res://Scenes/Arenas/arena_2.tscn")

var arenas : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.first_run:
		Globals.first_run = false
		overlay.show()
	arenas = [
		ARENA_0, ARENA_1, ARENA_2
	]
	load_next_arena()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func load_next_arena():
	if current_arena + 1 < arenas.size():
		arena.queue_free()
		current_arena += 1
		var arena_instance = arenas[current_arena].instantiate()
		add_child(arena_instance)

func reward_biscuits(amount):
	ShopData.biscuits += amount
