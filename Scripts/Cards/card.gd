extends TextureButton

@onready var control = $"../../.."


@onready var monster
@onready var card_sprite
@onready var cursed : bool = false # False - Join player team; True - Join enemy team

var click_blocker = preload("res://Scenes/UI/Misc/blocker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("toggled", _on_toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

## When card is pressed, have it be selected.
## With a card selected, create a monster at the location of the next
## left click.
func _on_toggled(toggled_on : bool):
	if toggled_on:
		self_modulate = Color(1.2,1.2,1.2,1)
	else:
		self_modulate = Color(1,1,1,1)
	control.card_selected = toggled_on
	control.monster_overlay.texture = card_sprite
	control.selected_card = self
