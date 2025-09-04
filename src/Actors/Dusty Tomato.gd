extends KinematicBody2D

signal player_hit

export var speed = Vector2(-5, 5)
export var spin: float = 0.17

const GRAVITY = 10
const SPEED = 100
const FLOOR = Vector2(0,-1)

onready var totalHealth = $HealthBar/TotalHealth

export var hp = 16
var inithp

var velocity = Vector2()
var direction = -1
var is_dead = false
var damage = 2

func _ready():
	inithp = hp
	if not is_in_group("slide_killable"):
		add_to_group("slide_killable")

func _dead(damage):
	hp = hp - damage
	totalHealth.scale.x = ((hp * 100.00) / inithp) / 100.00

	if hp <= 0 and is_dead == false:
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
		
	if is_on_wall():
		direction = direction * -1
#		$RayCast2D.position.x *= -1
#	if $RayCast2D.is_colliding() == false:
#	direction = direction * -1

func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var c = get_slide_collision(i)
			if c.collider and c.collider.is_in_group("player"):
				var player = c.collider
				if player.is_in_group("slope_slide") and not is_dead:
					_dead(hp)  # insta-kill; or _dead(4) for chunk damage
				else:
					player._dead(damage)


func _on_AnimatedSprite_animation_finished():
	if is_dead == true:
		queue_free()

