extends TextureButton

@onready var control = $"../.."

var cursed : bool = false # False - Join player team; True - Join enemy team

var monster
var click_blocker = preload("res://Scenes/UI/Misc/blocker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("toggled", _on_toggled)
	# Wait for object creation before assigning monster object as meta
	await get_tree().create_timer(0.2).timeout
	monster = get_meta("monster")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## When card is pressed, have it be selected.
## With a card selected, create a monster at the location of the next
## left click.
func _on_toggled(toggled_on : bool):
	control.card_selected = toggled_on
	control.selected_card = self
