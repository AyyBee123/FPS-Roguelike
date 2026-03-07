extends "res://Scripts/Enemies/rock_ball.gd"

var direction: Vector3

func _ready():
	ray_cast.global_transform = Transform3D(Basis(), ray_cast.global_position) # lock the ray cast's rotation
	ray_cast.force_raycast_update() # detect the ground immediately
	
	on_screen_notifier.screen_entered.connect(_on_screen_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)
	
	var size: Vector3 = scale
	scale = Vector3.ONE * 0.05
	spawn_tween = get_tree().create_tween()
	spawn_tween.tween_property(self, "scale", size, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	move_timer.start(randf_range(TICK_RATE / 2, TICK_RATE))

func _on_move_timer_timeout():
	move_timer.start(TICK_RATE)
	move(get_physics_process_delta_time())
