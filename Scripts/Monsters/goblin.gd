extends CharacterBody2D

@onready var arena = $".." # Connection to arena

@onready var sprite = $AnimatedSprite2D
@onready var walkbox = $Walkbox
@onready var hitbox = $Hitbox
@onready var sfx = $SFX
@onready var pathfinding = $Pathfinding
@onready var attack_cooldown = $AttackCooldown

@onready var projectile = preload("res://Scenes/Projectiles/rock.tscn")

enum Direction {UP, DOWN, LEFT, RIGHT}

## Type determines if monster belongs to the enemy or player.
## To be set on spawn. Friendly by default.
@export var type : Globals.ObjectType

## To be set to true when combat starts.
var combat_started : bool = false

# Monster Stats
var max_hp : int = 70
var hp : int = 50
var atk : int = 15
var knockback : int = 10
var weight : float = 0.9
var max_movement_speed : int = 40
var movement_speed : int = max_movement_speed
var lifesteal : float = 0
var facing : Direction = Direction.DOWN

# Monster Flags
var has_pathfinding : bool = false
var summon_exploder_on_death : bool = false
var current_target # This should contain a node I think, I am leaving it typeless for now

func _ready():
	sprite.connect("animation_finished", _on_animation_finished)
	pathfinding.connect("navigation_finished", _on_navigation_finished)
	# Wait to be moved into correct position by spawner
	await get_tree().create_timer(0.1).timeout
	arena.occupy_area(global_position.x, global_position.y)
	# Apply red tint if enemy
	if type == Globals.ObjectType.ENEMY:
		sprite.self_modulate = Color("ffb1a5")

func _physics_process(_delta):
	if hp > max_hp:
		hp = max_hp
	
	if combat_started and hp > 0:
		face_enemy()
		play_movement_animation()
		move_and_slide()
	
	if sprite.animation.substr(0,6) == "attack":
		if sprite.frame == 3:
			# Attack
			var projectile_instance = projectile.instantiate()
			arena.add_child(projectile_instance)
			# Setup projectile
			if type == Globals.ObjectType.FRIENDLY:
				projectile_instance.type = Globals.ObjectType.FRIENDLY_PROJECTILE
			elif type == Globals.ObjectType.ENEMY:
				projectile_instance.type = Globals.ObjectType.ENEMY_PROJECTILE
			projectile_instance.global_position = global_position
			projectile_instance.shot_direction = projectile_instance.global_position.direction_to(current_target.global_position)
			projectile_instance.damage = atk
			projectile_instance.knockback = knockback
			# Force next frame, otherwise if a frame lingers for 6-7 ticks,
			# 6-7 projectiles will spawn
			# This is not good practice and using animations as action controls is not a good idea
			# however by not planning the software architecture at the start, since
			# this was made for 7 days, I think it's the least of this game's issues.
			sprite.frame = 4

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
		pass
		# Start movement after a short duration to allow for
		# knockback to occur.
		await get_tree().create_timer(0.03).timeout
		pathfinding.moving = true

## Attack if target has been reached
func _on_navigation_finished():
	if hp < 0 or not combat_started:
		return
	if attack_cooldown.is_stopped():
		attack()

## Stop movement -> Melee Attack
## Attack by turning on hurtbox for 0.1 seconds
func attack() -> void:
	if hp < 0 or not combat_started:
		return
	attack_cooldown.start()
	print(name + " attacking!")
	# Stop movement
	velocity = Vector2(0,0)
	pathfinding.moving = false
	pathfinding.target_position = global_position
	velocity = Vector2(0,0)
	velocity = Vector2(0,0)
	play_attack_animation()

func get_closest_target(possible_targets : Array):
	if possible_targets.is_empty():
		return null
	var min_distance_target : float = 9999
	var chosen_target
	for target in possible_targets:
		var current_distance = global_position.distance_to(target.global_position)
		if current_distance < min_distance_target:
			min_distance_target = current_distance
			chosen_target = target
	return chosen_target

## Finds new target on the arena from the enemy team
func find_target() -> void:
	var possible_targets = []
	
	if hp < 0 or not combat_started:
		return
	if type == Globals.ObjectType.FRIENDLY:
		for object in arena.get_children():
			if "type" not in object:
				continue
			if object.type == Globals.ObjectType.ENEMY:
				possible_targets.append(object)
			current_target = get_closest_target(possible_targets)
		return
	elif type == Globals.ObjectType.ENEMY:
		for object in arena.get_children():
			if "type" not in object:
				continue
			if object.type == Globals.ObjectType.FRIENDLY:
				possible_targets.append(object)
			current_target = get_closest_target(possible_targets)
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
