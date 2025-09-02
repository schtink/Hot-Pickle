extends "res://src/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("wall_slide")
	add_state("stunned")
	add_state("dash")
	call_deferred("set_state", states.idle)

func _input(event):
	if parent.special_condition == "Water":
		if event.is_action_pressed("Jump"):
			parent.velocity.y = parent.max_jump_velocity
			parent.is_jumping = true
			AudioManager.play("res://assets/audio/effects/swim2.wav")
		return

	# Normal gravity levels: allow jump from idle, run, or fall if coyote is valid
	if [states.idle, states.run, states.fall].has(state):
		if event.is_action_pressed("Jump") and parent.can_coyote_jump():
			parent.do_jump()
			AudioManager.play("res://assets/audio/effects/jump2.wav")
			set_state(states.jump)  # immediate state for crisp animation and to avoid race conditions

	# Variable jump height cut
	if [states.jump, states.fall].has(state):
		if event.is_action_released("Jump") and parent.velocity.y < parent.min_jump_velocity:
			parent.velocity.y = parent.min_jump_velocity

	# Wall jump stays the same
	if state == states.wall_slide and event.is_action_pressed("Jump"):
		AudioManager.play("res://assets/audio/effects/hup.wav")
		parent._wall_jump()
		set_state(states.jump)

func _state_logic(delta):
	if Main.playerInert == false:
		parent._update_move_direction()
		parent._update_wall_direction()
		if state != states.wall_slide:
			parent._handle_move_input()
		parent._apply_gravity(delta)
		if state == states.wall_slide:
			parent._cap_gravity_wall_slide()
			parent._handle_wall_slide_sticky()
		parent._apply_movement(delta)

		# keep blur direction synced while dashing
		if state == states.dash:
			pass

func _get_transition(delta):
	# enter dash once when a dash is actually in progress
	if state != states.dash and parent.is_dashing:
		return states.dash

	match state:
		states.idle:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x != 0:
				return states.run
#			if parent.dash_timer.time_left > 0 and parent.velocity.x != 0:
#				return states.dash
		states.run:
			if !parent.is_grounded:
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x == 0:
				return states.idle
#			if parent.dash_timer.time_left > 0 and parent.velocity.x != 0:
#				return states.dash
		states.dash:
			# Stay in dash while the dash is active
			if parent.is_dashing:
				return null
			# Dash just ended. Choose next based on current motion
			if parent.is_grounded:
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
			else:
				return states.fall
		states.jump:
#			if parent.dash_timer.time_left > 0 and parent.velocity.x != 0:
#				return states.dash
			if parent.wall_direction != 0 && parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			elif parent.is_grounded:
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.wall_direction != 0 && parent.wall_slide_cooldown.is_stopped():
				return states.wall_slide
			elif parent.is_grounded:
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
#			if parent.dash_timer.time_left > 0 and parent.velocity.x != 0:
#				return states.dash
		states.wall_slide:
			if parent.is_grounded:
				return states.idle
			elif parent.wall_direction == 0:
				return states.fall
#			if parent.dash_timer.time_left > 0 and parent.velocity.x != 0:
#				return states.dash
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
		states.dash:
			pass

func _exit_state(old_state, new_state):
	match old_state:
		states.wall_slide:
			parent.wall_slide_cooldown.start()
		states.dash:
			pass

func _on_WallSlideStickyTimer_timeout():
	if state == states.wall_slide:
		set_state(states.fall)
