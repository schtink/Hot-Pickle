extends KinematicBody2D


export(String, FILE, "*.wav") var audioToPlay
var triggered = false

onready var raycast = $RayCast2D

func _physics_process(delta):
	if triggered == false and audioToPlay:
		if raycast.is_colliding() == true:
			AudioManager.play(audioToPlay)
			triggered = true
			Main.audiotriggered = true


func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				AudioManager.play(audioToPlay)
				triggered = true
