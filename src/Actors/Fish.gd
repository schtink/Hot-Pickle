extends KinematicBody2D

export var speed = 200
export var direction = -1
export var hp = 6
var inithp

var playerPosition = Vector2(5, 0)
var velocity = Vector2()
var is_dead = false
var is_angry = false
var gravity = 50

onready var totalHealth = $HealthBar/TotalHealth
onready var ray = get_node("RayCast2D")
onready var angrycollision = get_node("AngryCollision")
onready var normalcollision = get_node("CollisionShape2D")

func _ready():
	inithp = hp
	normalcollision.disabled = false
	angrycollision.disabled = true
	if direction <= -1:
		$AnimatedSprite.flip_h = true
		ray.cast_to.y *= -1

func _physics_process(_delta):
	_move()
	if is_dead == false:
		_collide_with_player()
		_getAngry()

func _move():
	if is_dead == false:
		velocity.x = speed * direction
	velocity = move_and_slide(velocity)

	if is_on_wall():
		direction = direction * -1
		if direction == 1:
			$AnimatedSprite.flip_h = false
			ray.cast_to.y *= -1
		elif direction <= 1:
			$AnimatedSprite.flip_h = true
			ray.cast_to.y *= -1

func _getAngry():
	if ray.is_colliding() == true:
		var collision = ray.get_collider()
		if collision.is_in_group("player") and is_angry == false:
			is_angry = true
			AudioManager.play("res://assets/audio/effects/chomp.wav")
			$AnimatedSprite.play("angry")
			normalcollision.disabled = true
			angrycollision.disabled = false
	else:
		$AnimatedSprite.play("swimming")
		normalcollision.disabled = false
		angrycollision.disabled = true

func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				get_slide_collision(i).collider._dead(1)

func _dead(damage):
	hp = hp - damage
	totalHealth.scale.x = ((hp * 100.00) / inithp) / 100.00
	if hp <= 0 and is_dead == false:
		is_dead = true
		totalHealth.scale.x = 0.0
		if $DeadTimer.is_stopped():
			$DeadTimer.start()
			$AnimatedSprite.play("dead")
			AudioManager.play("res://assets/audio/effects/die1.wav")

func _on_Sprite_animation_finished():
	if is_dead == true:
		$AnimatedSprite.play("stay_dead")
		$CollisionShape2D.disabled = true
		$AngryCollision.disabled = true
		velocity.x = 0
		velocity.y = gravity
	if is_angry == true && is_dead == false:
		$AnimatedSprite.play("swimming")
		is_angry = false
		normalcollision.disabled = false
		angrycollision.disabled = true
