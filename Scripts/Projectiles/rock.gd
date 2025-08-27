extends Area2D

@onready var type : Globals.ObjectType = Globals.ObjectType.NEUTRAL
@onready var damage : int = 0 # The summoning object should set this as its own ATK value
# The summoning object should set this as its own knockback value
@onready var knockback : int = 0 
# The summoning object should set this to point toward the enemy target
@onready var shot_direction : Vector2 = Vector2(0,0) 
@onready var projectile_speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	connect("body_entered", _on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# All frame dependent movement which is not executed by
	# move_and_slide() should be multiplied by delta in order
	# to have its speed be unaffected by the player's FPS
	global_position += (shot_direction * projectile_speed) * delta

# Hitboxes are areas
func _on_area_entered(area):
	if type == Globals.ObjectType.FRIENDLY_PROJECTILE:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.ENEMY:
			var knockback_direction = global_position.direction_to(area.get_parent().global_position)
			area.get_parent().take_damage(damage, knockback_direction*knockback)
			queue_free()
	elif type == Globals.ObjectType.ENEMY_PROJECTILE:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.FRIENDLY:
			var knockback_direction = global_position.direction_to(area.get_parent().global_position)
			area.get_parent().take_damage(damage, knockback_direction*knockback)
			queue_free()

# Walls and obstacles are bodies, pass through same team units,
# get destroyed in all other circumstances
func _on_body_entered(body):
	# Do not destroy under any circumstance if 
	# projectile doesn't yet have a type
	if type == Globals.ObjectType.NEUTRAL:
		return
	if type == Globals.ObjectType.FRIENDLY_PROJECTILE:
		if "type" not in body:
			return
		# Check for hitbox collision
		if body.type == Globals.ObjectType.FRIENDLY:
			return
		# Check for walkbox collision
		elif "type" in body.get_parent():
			if body.get_parent().type == Globals.ObjectType.FRIENDLY:
				return
	elif type == Globals.ObjectType.ENEMY_PROJECTILE:
		if "type" not in body:
			return
		# Check for hitbox collision
		if body.type == Globals.ObjectType.ENEMY:
			return
		# Check for walkbox collision
		elif "type" in body.get_parent():
			if body.get_parent().type == Globals.ObjectType.ENEMY:
				return
	else:
		queue_free()
		return
