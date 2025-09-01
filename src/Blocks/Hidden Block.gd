extends KinematicBody2D

var is_hidden = true
onready var raycast1 = $RayCast2D
onready var raycast2 = $RayCast2D2
onready var raycast3 = $RayCast2D3

func _ready():
	$CollisionShape2D.disabled = true
	$LightOccluder2D.visible = false

func _physics_process(delta):
		_break()

func _break():
	var raycasts = [raycast1, raycast2, raycast3]

	for raycast in raycasts:
		if raycast.is_colliding() == true:
			var collision = raycast.get_collider()
			if collision.is_in_group("player") && Input.is_action_pressed("Jump") && $CollisionTimer.is_stopped():
				$CollisionTimer.start()
				AudioManager.play("res://assets/audio/effects/Bump.wav")
				if is_hidden == true:
					$AnimatedSprite.play("null")
					is_hidden == false
					$CollisionShape2D.disabled = false
					$LightOccluder2D.visible = true
