extends Player

func _physics_process(delta):
	# add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * FALL_SPEED
	
	# get previous velocity
	var previous_velocity = velocity
	
	# recharge extra jumps
	if is_on_floor():
		current_jumps = NUMBER_OF_EXTRA_JUMPS
	
	# jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_HEIGHT
		jump.play_deconflicted()
	if Input.is_action_just_pressed("jump") and not is_on_floor() and current_jumps > 0:
		velocity.y = 0
		velocity.y += JUMP_HEIGHT
		current_jumps -= 1
		jump.play_deconflicted()
	
	# input direction and movement/deceleration
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_dashing:
		friction = 0.0
	else:
		friction = FRICTION if is_on_floor() else 5.0
	
	if direction.length() > 0.01:
		velocity.x = velocity.lerp(direction * SPEED, delta * friction).x
		velocity.z = velocity.lerp(direction * SPEED, delta * friction).z
	else:
		velocity.x = velocity.lerp(Vector3.ZERO, delta * friction).x
		velocity.z = velocity.lerp(Vector3.ZERO, delta * friction).z
	
	# dashing
	if Input.is_action_just_pressed("dash") and try_dash():
		dash.play_deconflicted()
		
		if input_dir.length() < 0.01:
			var cam_forward = -camera.global_transform.basis.z  # -z is forward
			cam_forward.y = 0  # keep it horizontal
			cam_forward = cam_forward.normalized()
			velocity += cam_forward * dash_speed
			on_dash.emit(dash_speed, Vector2(cam_forward.x, cam_forward.z))
		else:
			var cam_basis = camera.global_transform.basis
			var forward = cam_basis.z
			var right = cam_basis.x
			forward.y = 0
			right.y = 0
			forward = forward.normalized()
			right = right.normalized()
			var dash_dir = (forward * input_dir.y + right * input_dir.x).normalized()
			velocity += dash_dir * dash_speed
			on_dash.emit(dash_speed, input_dir)
		
		if velocity.y < 0: velocity.y = 2
		
		var dash_tween: Tween = get_tree().create_tween()
		dash_tween.tween_callback(func(): is_dashing = true)
		dash_tween.tween_interval(0.05)
		dash_tween.tween_callback(func(): is_dashing = false; velocity /= 4)
	
	# dash bars
	for i in range(dash_charges.size()):
		if dash_charges[i] > 0.0:
			dash_charges[i] = max(0.0, dash_charges[i] - delta)
	
	for i in range(dash_bar_array.size()):
		var cooldown = dash_charges[i]
		dash_bar_array[i].value = dash_bar_array[i].max_value - (cooldown / DASH_COOLDOWN)
	
	move_and_slide()
	
	# check for landing
	if not was_on_floor and is_on_floor():
		land.play_deconflicted()
		speed_before_landing = previous_velocity.y
		on_landing.emit(speed_before_landing)
	was_on_floor = is_on_floor()
	
	pickup = get_pickup_collision()
	if pickup and pickup.has_method("highlight"):
		if pickup is Chest or pickup is ArmoryBox:
			if coin_count >= pickup.cost:
				pickup.highlight()
		else:
			pickup.highlight()
	if hovered_item and hovered_item.has_method("unhighlight") and not pickup:
		hovered_item.unhighlight()
	hovered_item = pickup
	item_hovered.emit(pickup)
	
	# check for level ups
	if upgrade_queue_count > 0 and upgrade.get_child_count() == 0:
		level_up()
