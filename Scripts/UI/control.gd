extends Control

@onready var arena = $"../../Arena"
@onready var begin_combat = $BeginCombat
@onready var mouse_stop = $MouseStop
@onready var hand = $Hand

@onready var stats = $Stats
@onready var friendly_count = $Stats/FriendlyCount
@onready var enemy_count = $Stats/EnemyCount
@onready var combat_result = $Stats/CombatResult

@onready var collision_detector = $CollisionDetector
@onready var monster_overlay = $MonsterOverlay

@onready var soul_dough_count_label = $SlotMachine/SoulDough/CountLabel

@onready var overlay = $"../Overlay"
@onready var hide_overlay = $"../Overlay/Play"

@onready var error = $Error
@onready var error_timer = $Error/Timer

@onready var speak = $OvenPanel/Speak

## Clickable area in which monsters will be able to be spawned
## on click if a card has been previously selected.
@onready var arena_area = $ArenaArea 

var card_selected : bool = false	# Is a card selected?
var selected_card 					# Contains selected card
var can_click : bool = false		# True if mouse is in arena_area; False otherwise
var mouse_in_solid_object : bool = false

var soul_dough : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	begin_combat.connect("pressed", _on_begin_combat_pressed)
	arena_area.connect("mouse_entered", _on_mouse_entered)
	arena_area.connect("mouse_exited", _on_mouse_exited)
	collision_detector.connect("body_entered", _on_mouse_collision_start)
	collision_detector.connect("body_exited", _on_mouse_collision_end)
	hide_overlay.connect("pressed", _hide_overlay)
	error_timer.connect("timeout", _error_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	# Keep monster_overlay texture over mouse pos
	monster_overlay.global_position = get_global_mouse_position() - Vector2(12,18)
	collision_detector.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Check if click is inside arena
		if can_click and card_selected and not mouse_in_solid_object:
			var click_position : Vector2 = get_global_mouse_position()
			print("Click position: ", click_position) # Debug, remove
			# Check if area is occupied
			const CHECK_RADIUS : int = 30
			var in_occupied_area : bool = false
			for occupied_area in arena.occupied_areas:
				if (click_position - occupied_area).length() <= CHECK_RADIUS:
					in_occupied_area = true
					output_error("Can't spawn monster inside occupied area!")
					return
			if not in_occupied_area:
				spawn_monster(click_position)
				# Remove monster cursor overlay
				monster_overlay.texture = null
			else:
				print("Can't spawn monster inside occupied area!")
				output_error("Can't spawn monster inside occupied area!")

func _on_begin_combat_pressed() -> void:
	var friendly_monsters = arena.get_monster_count()[0]
	if friendly_monsters <= 0:
		print("Can't start combat with 0 friendly monsters!")
		output_error("Can't start combat with 0 friendly monsters!")
		return
	if not hand.validate():
		print("All cursed cards must be played!")
		output_error("All cursed cards must be played!")
		return
	# Disable all controls
	disable_all_controls()
	# Enable monster AI
	arena.start_combat()

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
	# If card is cursed, transform into enemy.
	if selected_card.cursed:
		monster_instance.type = Globals.ObjectType.ENEMY
	# Destroy card
	selected_card.button_pressed = false
	selected_card.queue_free()

func _on_mouse_entered() -> void:
	can_click = true

func _on_mouse_exited() -> void:
	can_click = false

func _on_mouse_collision_start(_body) -> void:
	mouse_in_solid_object = true
	
func _on_mouse_collision_end(_body) -> void:
	mouse_in_solid_object = false

func _hide_overlay():
	overlay.hide()

func update_stats(friendlies : int, enemies : int, result_message : String = "Combat result: ") -> void:
	friendly_count.text = "Friendlies left: " + str(friendlies)
	enemy_count.text = "Enemies left: " + str(enemies)
	combat_result.text = result_message

func add_soul_dough(amount : int) -> void:
	soul_dough += amount
	soul_dough_count_label.text = "Soul Dough: " + str(soul_dough)

func remove_soul_dough(amount : int) -> void:
	soul_dough -= amount
	if soul_dough < 0:
		soul_dough = 0
	soul_dough_count_label.text = "Soul Dough: " + str(soul_dough)

func output_error(errorString : String):
	error.text = errorString
	error_timer.start()
	
func _error_end():
	error.text = ""
