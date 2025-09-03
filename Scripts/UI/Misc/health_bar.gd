extends TextureProgressBar

const GREEN_GRADIENT = preload("res://CustomResources/green_gradient.tres")
const RED_GRADIENT = preload("res://CustomResources/red_gradient.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	max_value = get_parent().max_hp
	if get_parent().type == Globals.ObjectType.ENEMY:
		texture_progress = RED_GRADIENT
	else:
		texture_progress = GREEN_GRADIENT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# This is terrible for performance.
	value = get_parent().hp
