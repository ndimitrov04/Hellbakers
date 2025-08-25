extends Panel

var card_button_group = ButtonGroup.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("debug_take_card"):
		pass

## Add card to hand and add card button to hand button_group
## so only one card can be "active" or "chosen" at a time
func add_card(card):
	card.button_group = card_button_group
