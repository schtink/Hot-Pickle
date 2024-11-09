extends KinematicBody2D

signal player_hit

export var hp = 1

const GRAVITY = 10
const FLOOR = Vector2(0,-1)

var is_dead = false
var velocity = Vector2()

func _ready():
	if is_dead == false:
		var anim = get_node("AnimationPlayer").get_animation("bounce")
		anim.set_loop(true)
		get_node("AnimationPlayer").play("bounce")
	
func _dead(damage):
	hp = hp - damage
	if hp <= 0:
		is_dead = true
		$CollisionShape2D.disabled = true
		if $DeadTimer.is_stopped():
			$DeadTimer.start()
			$AnimatedSprite.play("dead")
			AudioManager.play("res://assets/audio/effects/die2.wav")

func _physics_process(delta):
	if is_dead == false:
		_collide_with_player()
		#_move()

func _move():
	velocity.x = 0
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				get_slide_collision(i).collider._dead()

func _on_AnimatedSprite_animation_finished():
	if is_dead == true:
		queue_free()
