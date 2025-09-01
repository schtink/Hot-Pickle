extends KinematicBody2D

const UP = Vector2(0, -1)
const SLOPE_STOP = 64
const DROP_THRU_BIT = 1

var velocity = Vector2()
var move_speed = 5 * Main.UNIT_SIZE
var gravity
var max_jump_velocity
var min_jump_velocity
var is_grounded
var is_jumping = false
var move_direction

var max_jump_height = 4.25 * Main.UNIT_SIZE
var min_jump_height = 1.85 * Main.UNIT_SIZE
var jump_duration = 0.5

onready var raycasts = $Raycasts

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta):
	_get_input()
	
	velocity.y += gravity * delta 
	
	if is_jumping && velocity.y >= 0:
		is_jumping = false
	
	var snap = Vector2.DOWN * 32 if !is_jumping else Vector2.ZERO
	
	if move_direction == 0 && abs(velocity.x) < SLOPE_STOP:
		velocity.x = 0
	
	var stop_on_slope = true if get_floor_velocity().x == 0 else false
	
	velocity = move_and_slide_with_snap(velocity, snap, UP, stop_on_slope)
	
	is_grounded = !is_jumping && get_collision_mask_bit(DROP_THRU_BIT) && _check_is_grounded()

	_assigned_animation()
	

func _input(event):
	if event.is_action_pressed("Jump") && is_grounded:
		if Input.is_action_pressed("Down"):
			if _check_is_grounded($DropThruRayCasts):
				set_collision_mask_bit(DROP_THRU_BIT, false)
		else:
			velocity.y = max_jump_velocity
			is_jumping = true
	
	if event.is_action_released("Jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity

func _get_input():
	move_direction = -int(Input.is_action_pressed("Move_Left")) + int(Input.is_action_pressed("Move_Right"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	if move_direction != 0:
		$Body.scale.x = move_direction

func _get_h_weight():
	return 0.2 if is_grounded else  0.1
 
func _check_is_grounded(raycasts = self.raycasts):
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	print("Not colliding")
	return false

func _assigned_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"

	elif velocity.x != 0:
		anim = "run"
	
	if $Body/AnimatedSprite.animation != anim:
		$Body/AnimatedSprite.play(anim)


func _on_Area2D_body_exited(body):
	set_collision_mask_bit(DROP_THRU_BIT, true)
