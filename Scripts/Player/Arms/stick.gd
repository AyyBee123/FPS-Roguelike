extends "res://Scripts/Player/Arms/arm.gd"

@onready var hitbox: Area3D = %Hitbox

func launch_projectile(point: Vector3):
	pass

func shoot():
	if not fire_rate_timer.is_stopped() or animation_player.current_animation == "Swing":
		return
	
	fire_rate_timer.start()
	animation_player.stop()
	animation_player.play(shoot_animation)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Swing":
		animation_player.play("Idle")

func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy") and body.has_method("hit"):
		body.hit(damage)

func set_monitoring(value: bool):
	hitbox.monitoring = value
