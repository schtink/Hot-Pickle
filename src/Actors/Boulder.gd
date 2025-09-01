extends KinematicBody2D

signal player_hit

export var speed = Vector2(-5, 5)
export var spin: float = 0.17

const GRAVITY = 2
const SPEED = 300
const FLOOR = Vector2(0,-1)

onready var totalHealth = $HealthBar/TotalHealth

export var hp = 4
var inithp

var velocity = Vector2()
var direction = 1
var is_dead = false

func _ready():
	inithp = hp

func _dead(damage):
	hp = hp - damage
	totalHealth.scale.x = ((hp * 100.00) / inithp) / 100.00
	print(totalHealth.scale.x)
	if hp <= 0:
		is_dead = true
		totalHealth.scale.x = 0.0
		velocity = 0
		$CollisionShape2D.disabled = true
		if $DeadTimer.is_stopped():
			$DeadTimer.start()
			$AnimatedSprite.play("dead")
			AudioManager.play("res://assets/audio/effects/die3.wav")

func _physics_process(delta):
	if is_dead == false:
		_move()
		_collide_with_player()
		
func _move():
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
		
	if direction == 1:
		rotate(spin)
	elif direction <= -1:
		rotate(-spin)
			
	velocity = move_and_slide(velocity, FLOOR)
		
#	if is_on_wall():
#		direction = direction * -1
#		$RayCast2D.position.x *= -1
#	if $RayCast2D.is_colliding() == false:
#	direction = direction * -1

func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				get_slide_collision(i).collider._dead(1)

func _on_AnimatedSprite_animation_finished():
	if is_dead == true:
		queue_free()

