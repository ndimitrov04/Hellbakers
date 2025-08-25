extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var walkbox = $Walkbox
@onready var hitbox = $Hitbox
@onready var sfx = $SFX

enum Direction {UP, DOWN, LEFT, RIGHT}

## Type determines if monster belongs to the enemy or player.
## To be set on spawn. Friendly by default.
@export var type : Globals.ObjectType

## To be set to true when combat starts.
var combat_started : bool = false

# Monster Stats
var hp : int = 100
var atk : int = 20
var attack_radius : float = 10
var knockback : int = 30
var weight : float = 1
var max_movement_speed : int = 20
var movement_speed : int = max_movement_speed
var lifesteal : float = 0
var facing : Direction = Direction.DOWN

# Monster Flags
var has_pathfinding : bool = false
var summon_exploder_on_death : bool = false
var current_target # This should contain a node I think, I am leaving it typeless for now

func _ready():
	sprite.connect("animation_finished", _on_animation_finished)

func _physics_process(delta):
	move_and_slide()

## Take damage and apply knockback effect
# Knockback is a positional vector which is added to the monster's current velocity
func take_damage(damage_taken : int, knockback : Vector2) -> void:
	# Take damage
	hp -= damage_taken
	# Take knockback
	velocity += knockback / weight

## Play death animation and remove object from arena
func die() -> void:
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
		queue_free()

## Detect if in range of enemy and attack.
## If in range of a given enemy which is not the
## target, make the new enemy the target.
func check_body_in_range(body) -> void:
	if type == Globals.ObjectType.FRIENDLY:
		if "type" not in body:
			return
		if body.type == Globals.ObjectType.ENEMY:
			current_target = body
			attack()
		return
	elif type == Globals.ObjectType.ENEMY:
		if "type" not in body:
			return
		if body.type == Globals.ObjectType.FRIENDLY:
			current_target = body
			attack()
		return

# Unique for every mosnter
func attack() -> void:
	pass

## Finds new target on the arena from the enemy team
# TBA - Target should be chosen based on distance from caster
func find_target() -> void:
	var arena = get_parent()
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
		if global_position.x < current_target.global_position.x:
			facing = Direction.RIGHT
		if global_position.x > current_target.global_position.x:
			facing = Direction.LEFT

		if global_position.y < current_target.global_position.y:
			facing = Direction.DOWN
		if global_position.y > current_target.global_position.y:
			facing = Direction.UP
