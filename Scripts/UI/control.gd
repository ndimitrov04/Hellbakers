extends Control

@onready var arena = $"../../Arena"
@onready var begin_combat = $BeginCombat
@onready var mouse_stop = $MouseStop

@onready var stats = $Stats
@onready var friendly_count = $Stats/FriendlyCount
@onready var enemy_count = $Stats/EnemyCount
@onready var combat_result = $Stats/CombatResult

## Clickable area in which monsters will be able to be spawned
## on click if a card has been previously selected.
@onready var arena_area = $ArenaArea 

## Unclickable Areas

var card_selected : bool = false	# Is a card selected?
var selected_card 					# Contains selected card
var can_click : bool = false		# True if mouse is in arena_area; False otherwise

# Called when the node enters the scene tree for the first time.
func _ready():
	begin_combat.connect("pressed", _on_begin_combat_pressed)
	arena_area.connect("mouse_entered", _on_mouse_entered)
	arena_area.connect("mouse_exited", _on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if can_click and card_selected:
			var click_position = get_global_mouse_position()
			print("Click position: ", click_position) # Debug, remove
			spawn_monster(click_position)
	
func _on_begin_combat_pressed() -> void:
	# Disable all controls
	disable_all_controls()
	# Enable monster AI
	for object in arena.get_children():
		if "combat_started" in object:
			object.combat_started = true

## Disable all child control nodes by intercepting mouse
## events via control in "mouse stop" mode.
func disable_all_controls() -> void:
	mouse_stop.mouse_filter = MouseFilter.MOUSE_FILTER_STOP

## Spawn monster at given coords
func spawn_monster(spawn_coords : Vector2) -> void:
	# Spawn monster
	var monster_instance = selected_card.monster.instantiate()
	arena.add_child(monster_instance)
	monster_instance.global_position = spawn_coords
	# TO-DO - Fix this, doesn't work.
	# Spawn click-blocker to prevent summoning monsters at the same position
	#var blocker_instance = selected_card.click_blocker.instantiate()
	#arena_area.add_child(blocker_instance)
	#blocker_instance.global_position = spawn_coords

func _on_mouse_entered() -> void:
	can_click = true
	
func _on_mouse_exited() -> void:
	can_click = false

func update_stats(friendlies : int, enemies : int, result_message : String = "Combat result: ") -> void:
	friendly_count.text = "Friendlies left: " + str(friendlies)
	enemy_count.text = "Enemies left: " + str(enemies)
	combat_result.text = result_message
