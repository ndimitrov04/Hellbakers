extends CharacterBody2D

@onready var arena = $".." # Connection to arena

@onready var sprite = $AnimatedSprite2D
@onready var walkbox = $Walkbox
@onready var hitbox = $Hitbox
@onready var sfx = $SFX
@onready var hurtbox = $Hurtbox
@onready var hurtbox_shape = $Hurtbox/Hurtbox
@onready var simple_movement = $SimpleMovement
@onready var attack_cooldown = $AttackCooldown

enum Direction {UP, DOWN, LEFT, RIGHT}

## Type determines if monster belongs to the enemy or player.
## To be set on spawn. Friendly by default.
@export var type : Globals.ObjectType

## To be set to true when combat starts.
var combat_started : bool = false

# Monster Stats
var hp : int = 100
var atk : int = 20
var knockback : int = 80
var weight : float = 1
var max_movement_speed : int = 30
var movement_speed : int = max_movement_speed
var lifesteal : float = 0
var facing : Direction = Direction.DOWN

# Monster Flags
var has_pathfinding : bool = false
var summon_exploder_on_death : bool = false
var current_target # This should contain a node I think, I am leaving it typeless for now

func _ready():
	sprite.connect("animation_finished", _on_animation_finished)
	simple_movement.attack_radius.connect("area_entered", check_area_in_range)
	hurtbox.connect("area_entered", _on_hurtbox_area_entered)

func _physics_process(_delta):
	if combat_started and hp > 0:
		face_enemy()
		play_movement_animation()
		move_and_slide()
	
	if sprite.animation.substr(0,6) == "attack":
		if sprite.frame == 2:
			# Attack
			hurtbox.monitoring = true

## Take damage and apply knockback effect
# Knockback is a positional vector which is added to the monster's current velocity
func take_damage(damage_taken : int, knockback_taken : Vector2) -> void:
	# Take damage
	hp -= damage_taken
	# Take knockback
	velocity += knockback_taken / weight
	# Check for death
	if hp <= 0:
		die()

## Play death animation and remove object from arena
func die() -> void:
	# If not already dying.
	var animation_name = sprite.animation
	if animation_name.substr(0,3) != "die":
		print(name + " has died!")
		match facing:
			Direction.UP:
				sprite.play("die_up")
			Direction.DOWN:
				sprite.play("die_down")
			Direction.LEFT:
				sprite.play("die_left")
			Direction.RIGHT:
				sprite.play("die_right")

# This function can be optimized, 
# no need to check if every animation is a death animation.

## Check if the finished animation is a death animation and kill monster if it is
func _on_animation_finished():
	var animation_name = sprite.animation
	print(animation_name.substr(0,3)) # for debugging, remove later
	if animation_name.substr(0,3) == "die":
		print(name + " has died!") # for debugging, remove later
		# Use to update monster counters
		arena.update_monster_count()
		queue_free()
	if animation_name.substr(0,6) == "attack":
		# Attack end
		hurtbox.monitoring = false
		# Start movement after a short duration to allow for
		# knockback to occur.
		await get_tree().create_timer(0.03).timeout
		simple_movement.moving = true

## Detect if in range of enemy and attack.
## If in range of a given enemy which is not the
## target, make the new enemy the target.
func check_area_in_range(area) -> void:
	if hp < 0 or not combat_started:
		return
	#print("Body detected: " + body.name ) # Debug, remove later
	if type == Globals.ObjectType.FRIENDLY:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.ENEMY:
			#print("Enemy detected: " + area.get_parent().name )
			current_target = area.get_parent()
			if attack_cooldown.is_stopped():
				attack()
		return
	elif type == Globals.ObjectType.ENEMY:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.FRIENDLY:
			#print("Enemy detected: " + area.get_parent().name )
			current_target = area.get_parent()
			if attack_cooldown.is_stopped():
				attack()
		return

## Stop movement -> Melee Attack
## Attack by turning on hurtbox for 0.1 seconds
func attack() -> void:
	if hp < 0 or not combat_started:
		return
	attack_cooldown.start()
	print(name + " attacking!")
	# Stop movement
	velocity = Vector2(0,0)
	simple_movement.moving = false
	velocity = Vector2(0,0)
	velocity = Vector2(0,0)
	play_attack_animation()
	
## Deal damage to enemy if hurtbox connects with a hitbox on a nearby enemy
func _on_hurtbox_area_entered(area):
	if hp < 0 or not combat_started:
		return
	if type == Globals.ObjectType.FRIENDLY:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.ENEMY:
			print(area.get_parent().name + " has been hit!")
			var knockback_direction = global_position.direction_to(area.get_parent().global_position)
			area.get_parent().take_damage(atk, knockback_direction*knockback)
		return
	elif type == Globals.ObjectType.ENEMY:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.FRIENDLY:
			print(area.get_parent().name + " has been hit!")
			var knockback_direction = global_position.direction_to(area.get_parent().global_position)
			area.get_parent().take_damage(atk, knockback_direction*knockback )
		return

## Finds new target on the arena from the enemy team
# TBA - Target should be chosen based on distance from caster
func find_target() -> void:
	if hp < 0 or not combat_started:
		return
	if type == Globals.ObjectType.FRIENDLY:
		for object in arena.get_children():
			if "type" not in object:
				continue
			if object.type == Globals.ObjectType.ENEMY:
				current_target = object
		return
	elif type == Globals.ObjectType.ENEMY:
		for object in arena.get_children():
			if "type" not in object:
				continue
			if object.type == Globals.ObjectType.FRIENDLY:
				current_target = object
		return

func face_enemy() -> void:
	if hp < 0 or not combat_started:
		return
	
	if current_target != null:
		var delta = current_target.global_position - global_position
		
		if abs(delta.x) > abs(delta.y):
			if delta.x > 0:
				facing = Direction.RIGHT
			else:
				facing = Direction.LEFT
		else:
			if delta.y > 0:
				facing = Direction.DOWN
			else:
				facing = Direction.UP

func play_movement_animation() -> void:
	if hp < 0 or not combat_started:
		return
	if sprite.animation == "idle":
		sprite.stop()
	if (abs(velocity.x) > 0 or abs(velocity.y) > 0) and not sprite.is_playing():
		match facing:
			Direction.UP:
				sprite.play("walk_up")
			Direction.DOWN:
				sprite.play("walk_down")
			Direction.LEFT:
				sprite.play("walk_left")
			Direction.RIGHT:
				sprite.play("walk_right")

func play_attack_animation() -> void:
	if hp < 0 or not combat_started:
		return
	match facing:
		Direction.UP:
			sprite.play("attack_up")
		Direction.DOWN:
			sprite.play("attack_down")
		Direction.LEFT:
			sprite.play("attack_left")
		Direction.RIGHT:
			sprite.play("attack_right")
