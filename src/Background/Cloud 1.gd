extends Area2D

export var is_animating = false
export var speed = -20
var velocity = Vector2()

func _physics_process(delta):
	if is_animating:
		velocity.x = speed * delta
		translate(velocity)
	pass
