extends Node2D

@onready var retarget = $Retarget
@onready var attack_radius = $AttackRadius
@onready var attack_radius_shape = $AttackRadius/Hitbox
@onready var check_radius = $AttackRadius/CheckRadius

# Might need to add acceleration to different characters and make this
# pull data from parent node.
const ACCELERATION : int = 1

var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	retarget.connect("timeout", _on_retarget_timeout)
	retarget.autostart = true
	retarget.start()
	check_radius.connect("timeout", _on_check_radius_timeout)
	# Await for creation of children
	await get_tree().create_timer(0.2).timeout
	attack_radius_shape.shape.radius = get_parent().hurtbox_shape.shape.radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_parent().combat_started and moving and get_parent().hp > 0:
		limit_speed()
		if get_parent().current_target != null:
			move_toward_target()
	
## Find new target on target timeout
func _on_retarget_timeout():
	get_parent().find_target()

func _on_check_radius_timeout():
	attack_radius.monitoring = false
	await get_tree().create_timer(0.05).timeout
	attack_radius.monitoring = true

## Control max speed of char; crude implementation
func limit_speed() -> void:
	# Limit X axis speed
	if get_parent().velocity.x > get_parent().movement_speed:
		get_parent().velocity.x = get_parent().movement_speed
	if get_parent().velocity.x < -(get_parent().movement_speed):
		get_parent().velocity.x = -(get_parent().movement_speed)
	# Limit Y axis speed
	if get_parent().velocity.y > get_parent().movement_speed:
		get_parent().velocity.y = get_parent().movement_speed
	if get_parent().velocity.y < -(get_parent().movement_speed):
		get_parent().velocity.y = -(get_parent().movement_speed)

## Move character toward target
func move_toward_target() -> void:
	# Move on X axis
	if get_parent().global_position.x < get_parent().current_target.global_position.x:
		get_parent().velocity.x += ACCELERATION
	if get_parent().global_position.x > get_parent().current_target.global_position.x:
		get_parent().velocity.x += -ACCELERATION
	# Move on Y axis
	if get_parent().global_position.y < get_parent().current_target.global_position.y:
		get_parent().velocity.y += ACCELERATION
	if get_parent().global_position.y > get_parent().current_target.global_position.y:
		get_parent().velocity.y += -ACCELERATION
