extends Node2D

@onready var timer = $Timer

@onready var spawn_area_1 = $SpawnArea1
@onready var top_left_1 = $SpawnArea1/TopLeft
@onready var bottom_right_1 = $SpawnArea1/BottomRight
@onready var spawn_area_2 = $SpawnArea2
@onready var top_left_2 = $SpawnArea2/TopLeft
@onready var bottom_right_2 = $SpawnArea2/BottomRight

@onready var arena = $".."

const CRAWLER = preload("res://Scenes/Monsters/crawler.tscn")
const GOBLIN = preload("res://Scenes/Monsters/goblin.tscn")
const SKELETON = preload("res://Scenes/Monsters/skeleton.tscn")
const STONE_GOLEM = preload("res://Scenes/Monsters/stone_golem.tscn")
const VAMPIRE = preload("res://Scenes/Monsters/vampire.tscn")
const ZOMBIE = preload("res://Scenes/Monsters/zombie.tscn")

var monsters = []
var teams = [Globals.ObjectType.FRIENDLY, Globals.ObjectType.ENEMY]

# Called when the node enters the scene tree for the first time.
func _ready():
	monsters = [CRAWLER, GOBLIN, SKELETON, STONE_GOLEM, ZOMBIE, VAMPIRE]
	timer.connect("timeout", _spawn_monster)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _spawn_monster():
	var monster = monsters.pick_random().instantiate()
	arena.add_child(monster)
	monster.type = teams.pick_random()
	if randf() > 0.5:
		var monster_x = randf_range(top_left_1.global_position.x, bottom_right_1.global_position.x)
		var monster_y = randf_range(top_left_1.global_position.y, bottom_right_1.global_position.y)
		monster.global_position = Vector2(monster_x, monster_y)
	else:
		var monster_x = randf_range(top_left_2.global_position.x, bottom_right_2.global_position.x)
		var monster_y = randf_range(top_left_2.global_position.y, bottom_right_2.global_position.y)
		monster.global_position = Vector2(monster_x, monster_y)
	monster.combat_started = true
