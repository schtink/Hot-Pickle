extends RigidBody2D

var shoot_power = 3
var power_up_used = false

func _physics_process(delta):
	apply_impulse(Vector2(0,0), Vector2(4,4))

func _on_Area2D_body_entered(body):
	if power_up_used == false:
		if body.is_in_group("player"):
			body._power_up(shoot_power)
			power_up_used = true
			AudioManager.play("res://assets/audio/effects/PowerUp.wav")
			queue_free()
