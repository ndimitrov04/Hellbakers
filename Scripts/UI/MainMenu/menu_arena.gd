extends Node2D

## Areas (Array : Vector2) occupied by monsters
var occupied_areas = []

## Areas (Array : Vector2) blocked by traps or impassable terrain
# TBA - Implement this.
var blocked_areas = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Returns: Vector2i(friendly_count, enemy_count)
func get_monster_count():
	pass

## Update monster count in GUI and check for combat end.
func update_monster_count() -> void:
	pass
	
## Turn on all monsters' AI
func start_combat() -> void:
	pass

## Turn off all monsters' AI
func end_combat(_result_victory : bool) -> void:
	pass

func occupy_area(_x : float, _y : float) -> void:
	pass
