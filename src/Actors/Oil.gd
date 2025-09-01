extends KinematicBody2D

signal player_hit
var is_dead = false

func _physics_process(delta):
	_collide_with_player()
	
func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				get_slide_collision(i).collider._dead(1)

func _dead(damage):
	pass
