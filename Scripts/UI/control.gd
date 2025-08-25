extends Control

@onready var arena = $"../../Arena"

@onready var begin_combat = $BeginCombat

# Called when the node enters the scene tree for the first time.
func _ready():
	begin_combat.connect("pressed", _on_begin_combat_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_begin_combat_pressed():
	for object in arena.get_children():
		if "combat_started" in object:
			object.combat_started = true
