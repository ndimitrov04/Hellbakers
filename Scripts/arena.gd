extends Node2D

@onready var control = $"../GUI/Control"
@onready var mouse_stop = $"../GUI/Control/MouseStop"
@onready var animation_player = $"../Overlay/AnimationPlayer"

const difficulty_subtractor : int = 35

## Areas (Array : Vector2) occupied by monsters
var occupied_areas = []

## Areas (Array : Vector2) blocked by traps or impassable terrain
# Deprecated
var blocked_areas = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Disable control blocker
	mouse_stop.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE
	# Update which arena scene the control.arena refers to
	control.arena = self
	get_parent().arena = self
	# Play strategy track
	Music.stream = Music.STRATEGY_THEME
	Music.play()
	# Give soul dough "buy in" for stage to player
	await get_tree().create_timer(0.2).timeout
	control.add_soul_dough(get_meta("soul_dough"))
	# Soul dough subtraction from base game
	control.remove_soul_dough(difficulty_subtractor)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## Returns: Vector2i(friendly_count, enemy_count)
func get_monster_count() -> Vector2i:
	var friendly_monsters : int = 0
	var enemy_monsters : int = 0
	for child in get_children():
		if "type" in child:
			if child.type == Globals.ObjectType.FRIENDLY:
				friendly_monsters += 1
			if child.type == Globals.ObjectType.ENEMY:
				enemy_monsters += 1
	return Vector2i(friendly_monsters, enemy_monsters)

## Update monster count in GUI and check for combat end.
func update_monster_count() -> void:
	# Wait for calling monster to die
	await get_tree().create_timer(0.2).timeout
	
	var friendly_monsters : int = 0
	var enemy_monsters : int = 0
	for child in get_children():
		if "type" in child:
			if child.type == Globals.ObjectType.FRIENDLY:
				friendly_monsters += 1
			if child.type == Globals.ObjectType.ENEMY:
				enemy_monsters += 1
	
	var combat_result : String = "Combat result: "
	if enemy_monsters == 0 and friendly_monsters == 0:
		combat_result = "Combat result: Draw!"
		end_combat(false)
		animation_player.play("transition")
	elif enemy_monsters == 0:
		combat_result = "Combat result: Player Wins!"
		end_combat(true)
		animation_player.play("transition")
	elif friendly_monsters == 0:
		combat_result = "Combat result: Enemy Wins!"
		end_combat(false)
		animation_player.play("transition")
	# Display result in GUI
	control.update_stats(friendly_monsters, enemy_monsters, combat_result)
	
## Turn on all monsters' AI
func start_combat() -> void:
	for object in get_children():
		if "combat_started" in object:
			object.combat_started = true

## Turn off all monsters' AI
func end_combat(result_victory : bool) -> void:
	for object in get_children():
		if "combat_started" in object:
			object.combat_started = false
			object.velocity = Vector2(0,0)
			object.sprite.animation = "idle"
	await get_tree().create_timer(0.5).timeout
	# Put a result screen or something here
	if result_victory:
		get_parent().load_next_arena()
	else:
		# Reward biscuits on death based on current arena
		get_parent().reward_biscuits(get_parent().current_arena*2)
		get_tree().reload_current_scene()

func occupy_area(x : float, y : float) -> void:
	occupied_areas.append(Vector2(x,y))
