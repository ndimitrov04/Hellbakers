extends Node2D

@onready var control = $"../GUI/Control"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

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
	elif enemy_monsters == 0:
		combat_result = "Combat result: Player Wins!"
	elif friendly_monsters == 0:
		combat_result = "Combat result: Enemy Wins!"
	# Display result in GUI
	control.update_stats(friendly_monsters, enemy_monsters, combat_result)
	
