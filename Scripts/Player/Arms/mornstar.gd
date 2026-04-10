extends Arm

@export var laser_points: Array[Marker3D]

@onready var arm = %Arm
@onready var bulb_1: MeshInstance3D = %Cylinder_005
@onready var bulb_2: MeshInstance3D = %Cylinder_004
@onready var bulb_3: MeshInstance3D = %Cylinder_003
@onready var charging = %Charging
@onready var heavy_beam = %"Heavy Beam"
@onready var beam_shrink = %"Beam Shrink"
@onready var mornstar_laser = %"Mornstar Laser"

const TICK_MULTIPLIER: float = 5

var is_shoot_button_held: bool = false
var laser: Node3D
var bar: ShaderMaterial

var fill_amount: float = 0.0:
	set(value):
		fill_amount = value
		%Arm.set_instance_shader_parameter("fill_amount", value)
var current_fill: float = 0.0

func _ready():
	super._ready()
	bar = %Arm.get_active_material(2)
	
	fill_amount = 0.0

func shoot(ignore_fire_rate: bool = false, outside_source: Variant = self):
	if laser:
		if t < fire_rate_timer and not ignore_fire_rate: return
		
		if not ignore_fire_rate:
			t = 0.0
		else:
			base_damage *= 2
			await get_tree().create_timer(1.0 / fire_rate).timeout
			base_damage /= 2
		fire_rate_timer = 1.0 / fire_rate
		
		player._on_arm_shot(self, outside_source)
		player._on_arm_fired(laser, damage)
	else:
		if not is_shoot_button_held:
			animation_player.play("Charge", -1, fire_rate / base_fire_rate)
		is_shoot_button_held = true

func launch_projectile(point: Vector3):
	var direction = (point - bullet_point.get_global_transform().origin).normalized()
	var proj = projectile.instantiate()
	
	proj.damage = damage
	proj.speed = speed
	proj.range = range
	proj.player = player
	proj.mornstar = self
	proj.tick_rate = 1.0 / (fire_rate * TICK_MULTIPLIER)
	proj.TICK_MULTIPLIER = TICK_MULTIPLIER
	proj.direction = direction
	
	Utils.copy_groups(self, proj)
	
	bullet_point.add_child(proj)
	player._on_arm_fired(proj, damage)
	
	laser = proj

func release(outside_source: Variant = self):
	super.release(outside_source)
	if is_shoot_button_held:
		animation_player.play("Shoot to Idle")
	is_shoot_button_held = false
	if laser:
		laser.shrink()
		beam_shrink.play_deconflicted()

func _physics_process(delta):
	super._physics_process(delta)
	
	if animation_player.current_animation == "Charge":
		fill_amount = animation_player.current_animation_position / animation_player.current_animation_length
		current_fill = fill_amount
	if animation_player.current_animation == "Shoot to Idle":
		fill_amount = current_fill - animation_player.current_animation_position / animation_player.current_animation_length
	
	light_bulb(bulb_1, 0.225)
	light_bulb(bulb_2, 0.525)
	light_bulb(bulb_3, 0.825)
	
	if laser:
		mornstar_laser.volume_db = linear_to_db(laser.scale.x)
		if not mornstar_laser.playing:
			mornstar_laser.play_deconflicted()
	else:
		mornstar_laser.stop()

func light_bulb(bulb: MeshInstance3D, threshold: float):
	if fill_amount > threshold:
		if not bulb.lit:
			bulb.lit = true
	else:
		if bulb.lit:
			bulb.lit = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Charge":
		animation_player.play("Charge to Shoot")
		launch_projectile(get_camera_point())
		heavy_beam.play_deconflicted()
	if anim_name == "Charge to Shoot":
		fill_amount = 1.0
		animation_player.play("Shoot")
	if anim_name == "Shoot to Idle":
		fill_amount = 0.0
		current_fill = 0.0
		animation_player.play("Idle")

func _on_animation_player_animation_started(anim_name):
	if anim_name == "Charge":
		charging.play_deconflicted(1)
	if anim_name != "Charge" and %Charging.playing:
		charging.stop()
