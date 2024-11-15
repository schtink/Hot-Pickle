extends "res://src/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("wall_slide")
	add_state("stunned")
	call_deferred("set_state", states.idle)

func _input(event):
	if parent.special_condition == "Water":
		if event.is_action_pressed("Jump"):
			parent.velocity.y = parent.max_jump_velocity
			parent.is_jumping = true
			AudioManager.play("res://assets/audio/effects/swim.wav")
	elif [states.idle, states.run].has(state):
		if event.is_action_pressed("Jump") && parent.is_grounded:
			parent.velocity.y = parent.max_jump_velocity
			parent.is_jumping = true
			AudioManager.play("res://assets/audio/effects/jump2.wav")

		if state == states.jump:
			if event.is_action_released("Jump") && parent.velocity.y < parent.min_jump_velocity:
				parent.velocity.y = parent.min_jump_velocity
	elif state == states.wall_slide:
		if event.is_action_pressed("Jump"):
			AudioManager.play("res://assets/audio/effects/hup.wav")
			parent._wall_jump()
			set_state(states.jump)

func _state_logic(delta):
	parent._update_move_direction()
	parent._update_wall_direction()
	if state != states.wall_slide:
		parent._handle_move_input()
	parent._apply_gravity(delta)
	if state == states.wall_slide:
		parent._cap_gravity_wall_slide()
		parent._handle_wall_slide_sticky()
	parent._apply_movement()

func _get_transition(delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
		states.jump:
			if parent.wall_direction != 0 && parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.wall_direction != 0 && parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		states.wall_slide:
			if parent.is_on_floor():
				return states.idle
			elif parent.wall_direction == 0:
				return states.fall
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.sprite.play("idle")
		states.run:
			parent.sprite.play("run")
		states.jump:
			parent.sprite.play("jump")
		states.fall:
			parent.sprite.play("fall")
		states.wall_slide:
			parent.sprite.play("wall_slide") #TO-DO -- Create Wall Slide Animation
			parent.body.scale.x = parent.wall_direction

func _exit_state(old_state, new_state):
	match old_state:
		states.wall_slide:
			parent.wall_slide_cooldown.start()


func _on_WallSlideStickyTimer_timeout():
	if state == states.wall_slide:
		set_state(states.fall)
