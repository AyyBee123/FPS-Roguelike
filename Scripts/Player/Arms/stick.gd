extends Arm

@onready var hitbox: Area3D = %Hitbox

func launch_projectile(point: Vector3):
	pass

func shoot(ignore_fire_rate: bool = false, outside_source = null):
	if (t < fire_rate_timer or animation_player.current_animation == "Swing") and not ignore_fire_rate:
		return
	
	if not ignore_fire_rate:
		t = 0.0
	
	fire_rate_timer = 1.0 / fire_rate
	animation_player.stop()
	animation_player.speed_scale = clamp(fire_rate / 2.0, 0.1, 8)
	animation_player.play(shoot_animation)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Swing":
		animation_player.speed_scale = 1
		animation_player.play("Idle")

func _on_area_3d_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)

func set_monitoring(value: bool):
	hitbox.monitoring = value
