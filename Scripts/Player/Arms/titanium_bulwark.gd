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

func shoot():
	if t < fire_rate_timer: return
	
	t = 0.0
	fire_rate_timer = 1.0 / fire_rate
	
	animation_player.stop()
	if shoot_animation != "":
		animation_player.play(shoot_animation, -1, fire_rate)
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self)
	
	launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()

func launch_projectile(_point: Vector3, _different_proj: PackedScene = null):
	if not barrier: return
	Utils.copy_groups(self, barrier)
	barrier.damage = damage
	barrier.push()
	player._on_arm_fired(barrier, damage)
