extends Sprite

signal player_dead_finished

func play_dead():
	$player_dead_animation.play("dead")

func _on_player_dead_animation_animation_finished(anim_name):
	emit_signal("player_dead_finished")
