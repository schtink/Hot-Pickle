extends Area2D

signal jar_collected

func _on_Pickle_Jar_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("player"):
		emit_signal("jar_collected")
		AudioManager.play("res://assets/audio/effects/bell.wav")
		queue_free()
