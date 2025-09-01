extends KinematicBody2D

signal player_hit

const FIREBALL = preload("res://src/Objects/Fireball.tscn")

export var speed = Vector2(-5, 5)
export var spin: float = 0.17

const GRAVITY = 10
const SPEED = 200
const FLOOR = Vector2(0,-1)

onready var totalHealth = $HealthBar/TotalHealth
onready var jumpTimer = $JumpTimer
onready var shootTimer = $ShootTimer

export var hp = 300
var inithp

var velocity = Vector2()
var direction = -1
var is_dead = false
var is_jumping = false
var is_shooting = false

func _ready():
	inithp = hp

func _dead(damage):
	hp = hp - damage
	totalHealth.scale.x = ((hp * 100.00) / inithp) / 100.00
	if hp > 0:
		AudioManager.play("res://assets/audio/effects/burger-ow-crushed.wav")
	if hp <= 0 and is_dead == false:
		Main.playerInert = true
		is_dead = true
		totalHealth.scale.x = 0.0
		$CollisionShape2D.disabled = true
		if $DeadTimer.is_stopped():
			$DeadTimer.start()
			$AnimatedSprite.play("dead")
			Main.beat_game = true
			AudioManager.play("res://assets/audio/effects/burger-defeated-crushed.wav")

func _physics_process(delta):
	if is_dead == false and Main.audiotriggered == true:
		_move()
		_collide_with_player()
	else:
		deathMove()
		$LightOccluder2D.visible = false

func deathMove():
	velocity.x = 0
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

func spitCheese():
	var shoot_weapon = FIREBALL.instance()

	if sign($Position2D.position.x) == 1:
		shoot_weapon._set_shoot_direction(1)
	else:
		shoot_weapon._set_shoot_direction(-1)
	shoot_weapon.position = $Position2D.global_position
		# sprite.play("shoot") #TO-DO Make shoot animation actually work
		#AudioManager.play("res://assets/audio/effects/shoot2.wav")
	get_parent().add_child(shoot_weapon)
#	AudioManager.play("res://assets/audio/effects/Fireball.wav")

func _move():
	if is_shooting == false:
		is_shooting = true
		shootTimer.start()
		spitCheese()
		
	if is_jumping == false:
		is_jumping = true
		AudioManager.play("res://assets/audio/effects/burger-jump-crushed.wav")
		jumpTimer.start()
		velocity.y = -1000
		velocity = move_and_slide(velocity, FLOOR)
	else:
		velocity.x = SPEED * direction
		velocity.y += GRAVITY

		velocity = move_and_slide(velocity, FLOOR)
		
	if is_on_wall():
		direction = direction * -1
		if direction == 1:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false

	if direction == -1:
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	if direction == 1:
		if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
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
		$AnimatedSprite.play("deadforever")
		Main.level_checkpoint = "none"
		Main.current_level = 1
		Main._save_player_data()
		Main.target_stage = "res://src/Cutscenes/Scene 4.tscn"
		Main.startSceneChange = true

func _on_JumpTimer_timeout():
	is_jumping = false


func _on_ShootTimer_timeout():
	is_shooting = false
