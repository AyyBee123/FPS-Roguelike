extends Arm

@onready var arm = %Arm

var barrier

func _ready():
	super._ready()

func on_pick_up():
	animation_player.play("Hold")
	
	barrier = projectile.instantiate()
	barrier.arm = self
	barrier.player = player
	player.camera.add_child(barrier)

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if t < fire_rate_timer and not ignore_fire_rate: return
	
	if not ignore_fire_rate:
		t = 0.0
	fire_rate_timer = 1.0 / fire_rate
	animation_player.stop()
	if shoot_animation != "":
		animation_player.play(shoot_animation, -1, fire_rate)
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self, outside_source)
	
	launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()

func launch_projectile(_point: Vector3):
	if barrier:
		barrier.queue_free()
	create_barrier()
	Utils.copy_groups(self, barrier)
	barrier.push()
	player._on_arm_fired(barrier, damage)

func create_barrier():
	barrier = projectile.instantiate()
	barrier.arm = self
	barrier.player = player
	player.camera.add_child(barrier)
