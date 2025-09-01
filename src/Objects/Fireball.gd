extends Area2D

const SPEED = 700
const SPIN = 0.4
var velocity = Vector2()
var direction = 1

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
#	rotate(SPIN)
	translate(velocity)
	pass

func _set_shoot_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false


func _on_Fireball_body_entered(body):
	if body.is_in_group("player") && body.has_method("_dead"):
		body._dead(1)
	queue_free()


func _on_Fireball_area_shape_exited(area_id, area, area_shape, local_shape):
	queue_free()
