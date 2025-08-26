extends NavigationAgent2D

@onready var retarget = $Retarget

# Might need to add acceleration to different characters and make this
# pull data from parent node.
const ACCELERATION : int = 1

var moving = true

# Called when the node enters the scene tree for the first time.
func _ready():
	retarget.connect("timeout", _on_retarget_timeout)
	retarget.autostart = true
	retarget.start()
	# Set desired target distance to enemy's attack range
	await get_tree().create_timer(0.1).timeout
	target_desired_distance = get_parent().hurtbox_shape.shape.radius + 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not moving:
		target_position = get_parent().global_position
	
	if get_parent().combat_started and moving and get_parent().hp > 0:
		limit_speed()
		if get_parent().current_target != null:
			#The velocity the enemy is going to move in (towards the target)
			get_parent().velocity = get_parent().global_position.direction_to(get_next_path_position()) * get_parent().movement_speed
	
## Find new target on target timeout (expensive)
func _on_retarget_timeout():
	get_parent().find_target()
	#Match navigation target point to target's position
	if get_parent().current_target != null:
		target_position = get_parent().current_target.global_position

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
