extends Player

func _physics_process(delta):
	camera.current = true
	
	# get previous velocity
	var previous_velocity = velocity
	
	# dash bars
	for i in range(dash_charges.size()):
		if dash_charges[i] > 0.0:
			dash_charges[i] = max(0.0, dash_charges[i] - delta)
	
	for i in range(dash_bar_array.size()):
		var cooldown = dash_charges[i]
		dash_bar_array[i].value = dash_bar_array[i].max_value - (cooldown / DASH_COOLDOWN)
	
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

func _input(_event):
	pass

func hit(_amount, _pos):
	pass
