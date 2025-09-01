extends Area2D

signal chicken_leg_collected

func _process(delta):
	rotate(0.01)

func _on_Donut_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group("player"):
		emit_signal("chicken_leg_collected")
		AudioManager.play("res://assets/audio/effects/eat.wav")
		Main.player_health += 1
		Main.player_health = clamp(Main.player_health, 0, 4)
		queue_free()
