extends Node3D

const XP = preload("uid://ukgrpto2cajc")

var time_left: float = 1200.0 # time in seconds (20 minutes, in this case)
var current_number_of_enemies: int

func _physics_process(delta):
	time_left = max(time_left - delta, 0)
	if time_left <= 0: # do stuff when countdown time reaches zero
		pass

func get_time_left():
	return time_left
