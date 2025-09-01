extends KinematicBody2D

var power_up_used = false
export var power_up = 3
onready var raycast1 = $RayCast2D
onready var raycast2 = $RayCast2D2
onready var raycast3 = $RayCast2D3

func _physics_process(delta):
		_break()

func _break():
	var raycasts = [raycast1, raycast2, raycast3]

	for raycast in raycasts:
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.is_in_group("player") && Input.is_action_pressed("Jump") && $CollisionTimer.is_stopped():
				$CollisionTimer.start()
				AudioManager.play("res://assets/audio/effects/Bump.wav")
				if power_up_used == false:
					var block_position = $BlockTop.global_position
					collision._instance_power_up(block_position, power_up)
					$AnimatedSprite.play("null")
					power_up_used = true
