extends KinematicBody2D

signal player_hit

export var speed = Vector2(-5, 5)
onready var raycast = $RayCast2D

const GRAVITY = 10
const SPEED = 100
const FLOOR = Vector2(0,-1)

export var hp = 3
var spin = 0.17

var velocity = Vector2()
var direction = -1
var is_dead = false

func _ready():
	direction = direction * -1

func _dead(damage):
	pass
#	hp = hp - damage
#	if hp <= 0:
#		is_dead = true
#		velocity = 0
#		$CollisionShape2D.disabled = true
#		if $DeadTimer.is_stopped():
#			$DeadTimer.start()
#			$AnimatedSprite.play("dead")
#			AudioManager.play("res://assets/audio/effects/die3.wav")

func _physics_process(delta):
	if is_dead == false:
		_move()
		_collide_with_player()
		
func _move():
	velocity.x = SPEED * direction
	velocity.y += GRAVITY

	velocity = move_and_slide(velocity, FLOOR)
		
	if is_on_wall():
		direction = direction * -1
		raycast.position.x *= -1
	if raycast.is_colliding() == false:
		direction = direction * -1
		raycast.position.x *= -1



func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				Main.dizzy = true
				get_slide_collision(i).collider._dead(1)

func _on_AnimatedSprite_animation_finished():
	pass
#	if is_dead == true:
#		queue_free()

