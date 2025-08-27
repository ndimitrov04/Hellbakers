extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	max_value = get_parent().max_hp

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# This is terrible for performance.
	value = get_parent().hp
