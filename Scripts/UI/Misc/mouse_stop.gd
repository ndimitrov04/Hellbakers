extends Control

# deprecated; do not use


@onready var control = $/root/Main/GUI/Control

var block_controls : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# This node is top level. Position must be manually updated.
	global_position = get_parent().global_position
	if block_controls:
		control.can_click = false

func _on_mouse_entered() -> void:
	print("controlblock")
	block_controls = true
	
func _on_mouse_exited() -> void:
	block_controls = false
	control.can_click = true
