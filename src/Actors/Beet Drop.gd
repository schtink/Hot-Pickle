extends KinematicBody2D

signal player_hit

const SPEED = 1000
const FLOOR = Vector2(0,-1)

onready var raycast = $RayCast2D
onready var timer = $DropTimer

var positionX

var is_dead = false
var damage = 1
var velocity = Vector2()
var dropping = false
var rising = false

func _ready():
	positionX = self.position.x

func _dead(damage):
	pass

func _physics_process(delta):
	if is_dead == false:
		self.position.x = positionX
		_move(delta)
		_collide_with_player()

func _move(delta):
	var collider = raycast.get_collider()
	if collider:
		if collider.is_in_group("player") and timer.is_stopped():
			timer.start()
			AudioManager.play("res://assets/audio/effects/drop.wav")
			dropping = true

	if dropping == true:
		velocity.y = SPEED * 1
		velocity = move_and_slide(velocity, FLOOR)
	elif rising == true:
		velocity.y = (SPEED/4) * -1
		velocity = move_and_slide(velocity, FLOOR)

	if is_on_wall() or is_on_floor():
		dropping = false
		rising = true
	
	if is_on_ceiling():
		rising = false

func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				get_slide_collision(i).collider._dead(damage)

func _on_DropTimer_timeout():
	dropping = false
	rising = true
