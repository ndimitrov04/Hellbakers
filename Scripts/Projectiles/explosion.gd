extends Area2D

@onready var timeout = $Timeout
@onready var cpu_particles_2d = $CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", _on_area_entered)
	timeout.connect("timeout", _on_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_area_entered(area):
	if "type" in area.get_parent():
		print("here1")
		if "hp" in area.get_parent():
			print("here2")
			var knockback_direction = global_position.direction_to(area.get_parent().global_position)
			area.get_parent().take_damage(65, knockback_direction * 200)

func _on_timeout():
	queue_free()
