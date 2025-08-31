extends Node2D

@onready var sounds_on = true

@onready var spawn = $Spawn
@onready var take_hit = $TakeHit
@onready var walk = $Walk
@onready var attack = $Attack
@onready var die = $Die

const hit = preload("res://Audio/PlaceholderAudio/hit.wav")
@export var walk_array : Array[AudioStreamWAV] = [
	preload("res://Audio/PlaceholderAudio/step.wav")
]
@export var attack_array : Array[AudioStreamWAV] = [
	
]
@export var death_array : Array[AudioStreamWAV] = [
	
]
@export var spawn_array : Array[AudioStreamWAV] = [
	
]

# Walk
func _process(_delta):
	if not walk.playing and (get_parent().velocity.x >= 2 or get_parent().velocity.y >= 2):
		walk.stream = walk_array.pick_random()
		walk.play()

# Play spawn sound only on friendlies
func _ready():
	await get_tree().create_timer(0.03).timeout
	if not sounds_on:
		spawn.volume_db = -90
		take_hit.volume_db = -90
		walk.volume_db = -90
		attack.volume_db = -90
		die.volume_db = -90
	if get_parent().type == Globals.ObjectType.FRIENDLY:
		spawn.stream = spawn_array.pick_random()
		spawn.play()

func play_take_hit():
	take_hit.stream = hit
	take_hit.play()

func play_attack():
	attack.stream = attack_array.pick_random()
	attack.play()

func play_death():
	die.stream = death_array.pick_random()
	die.play()
