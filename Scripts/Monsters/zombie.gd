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
var knockback : int = 3000
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

## Detect if in range of enemy and attack.
## If in range of a given enemy which is not the
## target, make the new enemy the target.
func check_area_in_range(area) -> void:
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
# To-do: Add attack animation logic
func attack() -> void:
	print(name + " attacking!")
	# Stop movement
	simple_movement.moving = false
	velocity = Vector2(0,0)
	await get_tree().create_timer(0.2).timeout
	# Attack
	hurtbox.monitoring = true
	attack_cooldown.start()
	await get_tree().create_timer(0.2).timeout
	hurtbox.monitoring = false
	# Start movement
	simple_movement.moving = true
	
## Deal damage to enemy if hurtbox connects with a hitbox on a nearby enemy
func _on_hurtbox_area_entered(area):
	if type == Globals.ObjectType.FRIENDLY:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.ENEMY:
			print(area.get_parent().name + " has been hit!")
			area.get_parent().take_damage(atk, Vector2(0,0))
		return
	elif type == Globals.ObjectType.ENEMY:
		if "type" not in area.get_parent():
			return
		if area.get_parent().type == Globals.ObjectType.FRIENDLY:
			print(area.get_parent().name + " has been hit!")
			area.get_parent().take_damage(atk, Vector2(0,0))
		return

## Finds new target on the arena from the enemy team
# TBA - Target should be chosen based on distance from caster
func find_target() -> void:
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
