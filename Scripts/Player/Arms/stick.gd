extends "res://Scripts/Player/Arms/arm.gd"

@onready var hitbox: Area3D = %Hitbox

func launch_projectile(point: Vector3):
	pass

func shoot():
	if t < fire_rate_timer or animation_player.current_animation == "Swing":
		return
	
	t = 0.0
	fire_rate_timer = 1.0 / fire_rate
	animation_player.stop()
	animation_player.speed_scale = clamp(0.1, fire_rate / 2.0, 8)
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
