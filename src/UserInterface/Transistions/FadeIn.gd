extends ColorRect

signal fadein_finished

func fade_in():
	$AnimationPlayer.play("FadeInAnimation")

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fadein_finished")
