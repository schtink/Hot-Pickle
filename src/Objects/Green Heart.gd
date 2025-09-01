extends Area2D

signal green_heart_collected

func _on_Green_Heart_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("player"):
		emit_signal("green_heart_collected")
		AudioManager.play("res://assets/audio/effects/yeah.wav")
		Main.player_lives += 1
		queue_free()
