extends CanvasLayer

@onready var COOK = $TextureRect/TextureRect/ExitButton/AudioStreamPlayer

@onready var animation_player = $AnimationPlayer

@onready var exit_button = $TextureRect/TextureRect/ExitButton

@onready var go_left = $TextureRect/TextureRect/GoLeft
@onready var go_right = $TextureRect/TextureRect/GoRight
@onready var machine_upgrade = $TextureRect/TextureRect/ShopPages/Shop3/MachineUpgrade

@onready var shop_pages = $TextureRect/TextureRect/ShopPages

@onready var biscuits = $TextureRect/TextureRect/Biscuits

var current_page : int = 0
var target_scroll_x : int = 0

const SCROLL_SPEED : int = 650

# Called when the node enters the scene tree for the first time.
func _ready():
	biscuits.text = "Biscuits: " + str(ShopData.biscuits)
	animation_player.play("RollIn")
	exit_button.connect("pressed", _exit_shop_pressed)
	go_left.connect("pressed", _go_left_pressed)
	go_right.connect("pressed", _go_right_pressed)
	machine_upgrade.connect("pressed", _machine_upgrade_pressed)
	Music.stream = Music.SHOP_THEME
	Music.play()


# This implementation of manual movement of the shop and
# node layout is stupid and inefficient. Do not do this in real projects.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if int(shop_pages.position.x) == target_scroll_x:
		pass
	elif shop_pages.position.x < target_scroll_x - 50:
		shop_pages.position.x += SCROLL_SPEED * delta
	elif shop_pages.position.x > target_scroll_x + 50:
		shop_pages.position.x -= SCROLL_SPEED * delta

func _exit_shop_pressed():
	animation_player.play("FadeOut")
	COOK.play()

func _go_left_pressed():
	if current_page == 0:
		return
	current_page -= 1
	target_scroll_x = current_page * -650  # Change to desired scroll position

func _go_right_pressed():
	if current_page == 2:
		return
	current_page += 1
	target_scroll_x = current_page * -650  # Change to desired scroll position

func _machine_upgrade_pressed():
	if ShopData.biscuits >= 10:
		ShopData.biscuits -= 10
		Upgrades.machine_upgrades += 25
		biscuits.text = "Biscuits: " + str(ShopData.biscuits)
