extends CanvasLayer

@onready var animation_player = $AnimationPlayer

@onready var exit_button = $TextureRect/TextureRect/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RollIn")
	exit_button.connect("pressed", _exit_shop_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _exit_shop_pressed():
	animation_player.play("FadeOut")
