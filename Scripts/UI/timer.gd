extends Label

@onready var level = get_tree().current_scene

func _physics_process(delta):
	var time = level.get_time_left()
	var minutes = time as int / 60
	var seconds = time as int % 60
	var milliseconds = (time as int * 100) % 100
	
	text = "%02d:%02d" % [minutes, seconds]
