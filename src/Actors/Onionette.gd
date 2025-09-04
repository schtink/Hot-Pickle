extends KinematicBody2D

signal player_hit

export var hp = 2
var inithp

const GRAVITY = 10
const FLOOR = Vector2(0,-1)

onready var totalHealth = $HealthBar/TotalHealth

var is_dead = false
var velocity = Vector2()

export var hop_offset := 24		# pixels left/right from the starting x
export var hop_height := 14		# pixels up for the hop arc
export var hop_time := 0.25		# time to go out (and also to return)
export var hop_pause := 0.10	# short pause before switching sides

var _base_pos := Vector2.ZERO


func _ready():
	inithp = hp
	if is_dead == false:
		var anim = get_node("AnimationPlayer").get_animation("bounce")
		anim.set_loop(true)
		get_node("AnimationPlayer").play("bounce")
		_base_pos = position
		_start_hops()

	
func _dead(damage):
	hp = hp - damage
	totalHealth.scale.x = ((hp * 100.00) / inithp) / 100.00

	if hp <= 0 and is_dead == false:
		is_dead = true
		position = _base_pos
		for c in get_children():
			if c is Tween:
				c.stop_all()
				c.queue_free()

		totalHealth.scale.x = 0.0
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
				get_slide_collision(i).collider._dead(1)

func _on_AnimatedSprite_animation_finished():
	if is_dead == true:
		queue_free()
		
func _start_hops() -> void:
	# run forever: left hop, then right hop
	call_deferred("_hop_cycle")

func _hop_cycle() -> void:
	if is_dead:
		return
	yield(_hop_one_side(-1), "tween_all_completed")
	if is_dead:
		return
	yield(get_tree().create_timer(hop_pause), "timeout")
	yield(_hop_one_side(1), "tween_all_completed")
	if is_dead:
		return
	yield(get_tree().create_timer(hop_pause), "timeout")
	call_deferred("_hop_cycle")	# loop

func _hop_one_side(dir: int) -> Tween:
	# dir = -1 (left), +1 (right)
	var tw := Tween.new()
	add_child(tw)

	# horizontal: center -> side -> center
	tw.interpolate_property(self, "position:x",
		position.x, _base_pos.x + dir * hop_offset,
		hop_time, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.0)
	tw.interpolate_property(self, "position:x",
		_base_pos.x + dir * hop_offset, _base_pos.x,
		hop_time, Tween.TRANS_CUBIC, Tween.EASE_IN, hop_time)

	# vertical arc: up then down (overlaps the first horizontal leg)
	tw.interpolate_property(self, "position:y",
		_base_pos.y, _base_pos.y - hop_height,
		hop_time * 0.5, Tween.TRANS_SINE, Tween.EASE_OUT, 0.0)
	tw.interpolate_property(self, "position:y",
		_base_pos.y - hop_height, _base_pos.y,
		hop_time * 0.5, Tween.TRANS_SINE, Tween.EASE_IN, hop_time * 0.5)

	tw.start()
	return tw
