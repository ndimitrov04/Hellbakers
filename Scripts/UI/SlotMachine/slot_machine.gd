extends AnimatedSprite2D

@onready var clickable_area = $ClickableArea
@onready var hand = $"../Hand"
@onready var count_label = $SoulDough/CountLabel

var pull_cost : int = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	clickable_area.connect("gui_input", _on_click)
	connect("animation_finished", _on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_click(event: InputEvent):
	if event.is_action_pressed("LMB") and animation == "idle":
		if hand.h_box_container.get_child_count() < 8:
			play("pull")

func _on_animation_finished():
	if animation == "pull":
		hand.add_card(hand.generate_random_card(get_parent().soul_dough))
		get_parent().remove_soul_dough(pull_cost)
		play("idle")
