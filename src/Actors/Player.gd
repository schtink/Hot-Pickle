extends KinematicBody2D

const PEPPERCORN = preload("res://src/Objects/Peppercorn.tscn")
const CORN = preload("res://src/Objects/Corn.tscn")
const CORN_COB = preload("res://src/Objects/CornCob.tscn")
const PEPPER_SHAKER = preload("res://src/Objects/Pepper Shaker.tscn")
const CHICKEN_LEG = preload("res://src/Objects/Chicken-Leg.tscn")
const HEART = preload("res://src/Objects/Green Heart.tscn")
const TOMATO = preload("res://src/Actors/Angry Tomato.tscn")
const ONION = preload("res://src/Actors/Onionette.tscn")
const SHROOM = preload("res://src/Actors/Dizzy Shroom.tscn")

const FLOOR_NORMAL = Vector2(0,-1)
const SAVE_KEY = "green_pickle"
const WALL_JUMP_VELOCITY = Vector2(800, -1000)
const UP = Vector2(0, -1)
const SLOPE_STOP = 64
const DROP_THRU_BIT = 1

var velocity = Vector2()
var move_speed = 5 * Main.UNIT_SIZE
var gravity
var max_jump_velocity
var min_jump_velocity
var move_direction = 1
var wall_direction = 1

var max_jump_height = 4.25 * Main.UNIT_SIZE
var min_jump_height = 0.85 * Main.UNIT_SIZE
var jump_duration = 0.5

# States
var is_attacking = false
var is_dead = false
var is_grounded
var is_dashing = false
var is_jumping = false
var is_falling = false
var is_wall_sliding = false
var is_stunned = false

# Special character behaviors base don level type
export(String, "Normal", "Water", "Space", "Auto") var special_condition

onready var level_checkpoint = get_owner().get_node("Checkpoint")
onready var checkpoint_position = get_owner().get_node("Checkpoint/Position2D")
onready var level_checkpoint2 = get_owner().get_node("Checkpoint2")
onready var checkpoint_position2 = get_owner().get_node("Checkpoint2/Position2D")
onready var sprite : AnimatedSprite = get_node("Body/hot_pickle")
onready var shoot_timer = $ShootTimer
onready var dash_timer = $DashTimer
onready var raycast1 = $RayCast2D
onready var raycast2 = $RayCast2D2
onready var raycast3 = $RayCast2D3
#onready var left_wall_raycasts = $WallRayCasts/LeftWallRayCasts
#onready var right_wall_raycasts = $WallRayCasts/RightWallRayCasts
onready var left_wall_raycast_1 = $LeftWallRayCast1
onready var left_wall_raycast_2 = $LeftWallRayCast2
onready var right_wall_raycast_1 = $RightWallRayCast1
onready var right_wall_raycast_2 = $RightWallRayCast2

onready var body = $Body
onready var wall_slide_cooldown = $WallSlideCoolDown
onready var wall_slide_sticky_timer = $WallSlideStickyTimer

func _ready():
	Main._refresh_player_data()
	_start_point()
	if special_condition == "Water":
		dash_timer.wait_time = 1.0
		jump_duration = 0.8
		min_jump_height = 0
		max_jump_height = 1.6 * Main.UNIT_SIZE
	if special_condition == "Space":
		dash_timer.wait_time = 2.0
		jump_duration = 1.3
		max_jump_height = 6 * Main.UNIT_SIZE
	_set_gravity_and_velocity()

func _set_gravity_and_velocity():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _start_point():
	if is_instance_valid(level_checkpoint2):
		if Main.level_checkpoint == level_checkpoint2.level_checkpoint:
			global_position = checkpoint_position2.global_position
	if is_instance_valid(level_checkpoint):
		if Main.level_checkpoint == level_checkpoint.level_checkpoint:
			global_position = checkpoint_position.global_position

func _physics_process(delta):
	
	if is_dead == false and Main.playerInert == false:
	#	_handle_move_input()
		if is_stunned == false:
			_collide_with_enemy()
		else:
			sprite.modulate.a = 0.0 if Engine.get_frames_drawn() % 2 == 0 else 1.0
	#	_apply_gravity(delta)
	#	_apply_movement()
		if Main.power_up >= 1:
			_shoot()

func _apply_gravity(delta):
	velocity.y += gravity * delta 

func _apply_movement():
	if is_jumping && velocity.y >= 0:
		is_jumping = false

	var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO

	if move_direction == 0 && abs(velocity.x) < SLOPE_STOP:
		velocity.x = 0

	var stop_on_slope = true if get_floor_velocity().x == 0 else false

	velocity = move_and_slide_with_snap(velocity, snap, UP, stop_on_slope)

	is_grounded = !is_jumping && _check_is_grounded()

func _update_move_direction():
	if !(Input.is_action_just_pressed("Dash")) && special_condition != "Auto":
		move_direction = -int(Input.is_action_pressed("Move_Left")) + int(Input.is_action_pressed("Move_Right"))
	elif special_condition == "Auto":
		move_direction = 1
	elif (dash_timer.is_stopped()) && !is_jumping && !velocity.y > 0 && velocity.x != 0:
		AudioManager.play("res://assets/audio/dash.wav")
		sprite.play("dash")
		dash_timer.start();
		is_dashing = true
		move_direction = -int(Input.is_action_pressed("Move_Left")) + int(Input.is_action_pressed("Move_Right"))
		#velocity.x = lerp(velocity.x, move_speed * move_direction * 32, _get_h_weight())
		velocity.x += move_direction * move_speed * 4
		velocity.y = max_jump_velocity /2
	elif (dash_timer.is_stopped()) && velocity.y < 0:
		AudioManager.play("res://assets/audio/dash.wav")
		sprite.play("dash")
		dash_timer.start();
		is_dashing = true
		move_direction = -int(Input.is_action_pressed("Move_Left")) + int(Input.is_action_pressed("Move_Right"))
		#velocity.x = lerp(velocity.x, move_speed * move_direction * 32, _get_h_weight())
		velocity.x += move_direction * move_speed * 2.5


func _handle_move_input():
	_update_move_direction()
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	if move_direction != 0:
		body.scale.x = move_direction

	if move_direction == -1:
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1
	if move_direction == 1:
		if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1

func _wall_jump():
	var wall_jump_velocity = WALL_JUMP_VELOCITY
	wall_jump_velocity.x *= -wall_direction
	velocity = wall_jump_velocity
	
func _shoot():
	if Input.is_action_just_pressed("Interact") && shoot_timer.is_stopped():
		is_attacking = true
		shoot_timer.start()
		var shoot_weapon
		if Main.power_up == 1:
			shoot_weapon = PEPPERCORN.instance()
		elif Main.power_up == 3:
			shoot_weapon = CORN.instance()

		if sign($Position2D.position.x) == 1:
			shoot_weapon._set_shoot_direction(1)
		else:
			shoot_weapon._set_shoot_direction(-1)
		shoot_weapon.position = $Position2D.global_position
		# sprite.play("shoot") #TO-DO Make shoot animation actually work
		AudioManager.play("res://assets/audio/effects/shoot2.wav")
		get_parent().add_child(shoot_weapon)

func _on_hot_pickle_animation_finished():
	if sprite.animation == "shoot":
		is_attacking = false

func _handle_wall_slide_sticky():
	if move_direction != 0 && move_direction != wall_direction:
		if wall_slide_sticky_timer.is_stopped():
			wall_slide_sticky_timer.start()
	else:
		wall_slide_sticky_timer.stop()

func _get_h_weight():
	if is_on_floor():
		return 0.2
	else:
		if move_direction == 0:
			return 0.02
		elif move_direction == sign(velocity.x) && abs(velocity.x) > move_speed:
			return 0.0
		else:
			return 0.1
	#return 0.2 if is_grounded else  0.1
 
func _check_is_grounded():
	#for raycast in raycasts.get_children():
		if raycast1.is_colliding() or raycast2.is_colliding() or raycast3.is_colliding():
			return true
		return false

func _collide_with_enemy():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if is_instance_valid(collision.collider):
				if collision.collider.is_in_group("enemy") or collision.collider.is_in_group("dropzone"):
					if collision.collider.is_dead == false:
						if collision.collider.is_in_group("dropzone"):
							Main.player_health = 0
						if collision.collider.is_in_group("dizzy"):
							Main.dizzy = true
						if collision.collider.is_in_group("double"):
							_dead(2)
						_dead(1)

func _drop_health(damage):
	Main.player_health -= damage

func _dead(damage):
	if Main.playerInert == false:
		if Main.player_health > 1 && $HitTimer.is_stopped():
			$HitTimer.start()
			_drop_health(damage)
			if is_stunned == false && $StunTimer.is_stopped():
				is_stunned = true
				$StunTimer.start()
				AudioManager.play("res://assets/audio/effects/ow.wav")
		elif $HitTimer.is_stopped():
			$HitTimer.start()
			is_dead = true
			if Main.player_lives >= 1:
				Main.player_lives -= 1
			velocity = Vector2(0,0)
			$CollisionShape2D.disabled = true
			sprite.hide()
			$player_dead.show()
			$player_dead.play_dead()
			AudioManager.play("res://assets/audio/effects/ohno.wav")
			
			#important!
			Main.player_health -= 1
			Main.reset_player_stats = true

func _on_player_dead_player_dead_finished():
	if Main.player_lives >= 1:
		get_tree().change_scene("res://src/UserInterface/Remaining Lives.tscn")
	if Main.player_lives < 1: #Game Over Man!
		Main._reset_to_defaults()
		get_tree().change_scene("res://src/UserInterface/Game Over.tscn")
	Main._save_player_data()

func _power_up(power_up):
		Main.power_up = power_up

func _instance_power_up(block_position, power_up):
	var power
	if power_up == 1:
		power = PEPPER_SHAKER.instance()
	elif power_up == 2:
		power = SHROOM.instance()
	elif power_up == 3:
		power = CORN_COB.instance()
	elif power_up == 4:
		power = CHICKEN_LEG.instance()
	elif power_up == 5:
		power = HEART.instance()
	elif power_up == 6:
		power = TOMATO.instance()
	elif power_up == 7:
		power = ONION.instance()
	power.position = block_position
	get_parent().add_child(power)

func _cap_gravity_wall_slide():
	var max_velocity = 256 if !Input.is_action_pressed("Down") else 6 * 256
	velocity.y = min(velocity.y, max_velocity)

func _update_wall_direction():
	var left_wall_raycasts = [left_wall_raycast_1, left_wall_raycast_2]
	var right_wall_raycasts = [right_wall_raycast_1, right_wall_raycast_2]
	
	var is_near_wall_left = _check_is_valid_wall(left_wall_raycasts)
	var is_near_wall_right = _check_is_valid_wall(right_wall_raycasts)
	
	if is_near_wall_left && is_near_wall_right:
		wall_direction = move_direction
	else:
		wall_direction = -int(is_near_wall_left) + int(is_near_wall_right)

func _check_is_valid_wall(wall_raycasts):
	for raycast in wall_raycasts:
		if raycast.is_colliding():
			#if raycast.get_collision_mask_bit(3):
			#	return false
			#else:
				var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
				if dot > PI * 0.35 && dot < PI * 0.55:
					return true
	return false

func _on_StunTimer_timeout():
	is_stunned = false
	sprite.modulate.a = 1.0


func _on_DashTimer_timeout():
	is_dashing = false
