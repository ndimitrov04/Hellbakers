extends Control

@onready var COOK = $Panel/play_button/AudioStreamPlayer

@onready var animation_player = $Overlay/AnimationPlayer

@onready var play_button = $Panel/play_button
@onready var quit_button = $Panel/quit_button
@onready var credits_button = $Panel/credits_button

const MAIN = "res://Scenes/main.tscn"

@onready var texture_rect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(MAIN)
	play_button.connect("pressed", _on_play_pressed)
	credits_button.connect("toggled", _on_credits_toggled)
	quit_button.connect("pressed", _on_quit_pressed)
	animation_player.connect("animation_finished", _on_animation_finished)
	Music.stream = Music.TITLE_THEME
	Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_play_pressed():
	animation_player.play("transition")
	COOK.play()
	
func _on_quit_pressed():
	get_tree().quit()

func _on_animation_finished(_animation_name):
	var main = ResourceLoader.load_threaded_get(MAIN)
	get_tree().change_scene_to_packed(main)

func _on_credits_toggled(toggle):
	if toggle:
		texture_rect.show()
	else:
		texture_rect.hide()
