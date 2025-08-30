extends Area2D

@onready var timeout = $Timeout
@onready var cpu_particles_2d = $CPUParticles2D

@onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	timeout.connect("timeout", _on_timeout)
	sprite.connect("animation_finished", _on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_area_entered(area):
	if "type" in area.get_parent():
		print("here1")
		if "hp" in area.get_parent():
			print("here2")
			var knockback_direction = global_position.direction_to(area.get_parent().global_position)
			area.get_parent().take_damage(45, knockback_direction * 350)

func _on_timeout():
	queue_free()

func _on_animation_finished():
	sprite.queue_free()
