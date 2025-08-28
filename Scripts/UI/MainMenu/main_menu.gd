extends Control

@onready var animation_player = $Overlay/AnimationPlayer

@onready var play_button = $Panel/play_button
@onready var quit_button = $Panel/quit_button

const MAIN = "res://Scenes/main.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(MAIN)
	play_button.connect("pressed", _on_play_pressed)
	quit_button.connect("pressed", _on_quit_pressed)
	animation_player.connect("animation_finished", _on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_play_pressed():
	animation_player.play("transition")
	
func _on_quit_pressed():
	get_tree().quit()

func _on_animation_finished(_animation_name):
	var main = ResourceLoader.load_threaded_get(MAIN)
	get_tree().change_scene_to_packed(main)
