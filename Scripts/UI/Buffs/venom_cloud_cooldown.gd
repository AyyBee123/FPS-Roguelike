extends Buff

func set_buff(_num):
	var time_left = clamp(cooldown - _num, 0, cooldown)
	
	number.text = "%*.*fs" % [0, 1, time_left]
	
	if _num >= cooldown:
		queue_free()
