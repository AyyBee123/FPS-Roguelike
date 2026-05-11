extends Arm

@onready var spray: DeconflictedAudioPlayer = %Spray

const TICK_MULTIPLIER: float = 5

var is_shoot_button_held: bool = false
var laser: Node3D

func _physics_process(delta):
	super._physics_process(delta)
	
	if laser and laser.is_drawing:
		if not spray.playing:
			spray.play_deconflicted()
	else:
		spray.stop()

func shoot():
		if t < fire_rate_timer or is_shoot_button_held: return
		
		t = 0.0
		fire_rate_timer = 1.0 / fire_rate
		
		animation_player.play("Idle to Shoot")
		if not laser:
			recoil_multiplier = 1
			launch_projectile(get_camera_point())
		else:
			recoil_multiplier = 0
		
		for audio in firing_audio:
			if audio:
				audio.play_deconflicted()
		
		player._on_arm_shot(self)
		player._on_arm_fired(laser, damage)
		is_shoot_button_held = true

func launch_projectile(point: Vector3, _different_proj: PackedScene = null):
	var direction = (point - bullet_point.get_global_transform().origin).normalized()
	var proj = projectile.instantiate()
	
	proj.damage = damage
	proj.speed = speed
	proj.range = range
	proj.player = player
	proj.blot = self
	proj.tick_rate = 1.0 / (fire_rate * TICK_MULTIPLIER)
	proj.TICK_MULTIPLIER = TICK_MULTIPLIER
	proj.direction = direction
	
	Utils.copy_groups(self, proj)
	
	bullet_point.add_child(proj)
	player._on_arm_fired(proj, damage)
	
	laser = proj

func release():
	super.release()
	if is_shoot_button_held and laser:
		animation_player.play("Shoot to Idle")
	is_shoot_button_held = false
	if laser:
		laser.shrink()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Idle to Shoot":
		animation_player.play("Shoot")
	if anim_name == "Shoot to Idle":
		animation_player.play("Idle")
	
