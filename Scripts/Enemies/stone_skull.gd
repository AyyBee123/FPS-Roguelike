extends Enemy

@onready var skull = %Skull
@onready var fire = %Fire
@onready var shoot_time = %"Shoot Time"
@onready var shoot_marker = %"Shoot Marker"

@export var projectile_damage: float
@export var projectile_speed: float
@export var projectile_range: float

const MUZZLE_FLASH = preload("uid://bx1wgwev3fm10")
const STONE_SKULL_PROJECTILE = preload("uid://bvanm1m1uxxy7")

var player_pos: Vector3
var can_shoot: bool = false

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	move(delta)
	
	if can_shoot and shoot_time.is_stopped():
		shoot()

func move(delta):
	if not player_pos: return
	
	if player_pos.y > global_position.y:
		position.y = lerp_angle(position.y, player_pos.y + raycast_offset, 0.02)
	else:
		position.y = lerp_angle(position.y, ray_cast.get_collision_point().y + raycast_offset, 0.05)
	
	if position.distance_to(player_pos) > 15:
		position.x += (player_pos.x - position.x) * delta * speed
		position.z += (player_pos.z - position.z) * delta * speed
		can_shoot = false
	elif position.distance_to(player_pos) > 12:
		position.x += (player_pos.x - position.x) * delta * speed * 0.1
		position.z += (player_pos.z - position.z) * delta * speed * 0.1
		can_shoot = true
	else:
		can_shoot = true
	
	skull.look_at(player_pos, Vector3.UP)
	
	move_and_slide()

func shoot():
	if is_on_screen:
		var muzzle = MUZZLE_FLASH.instantiate()
		shoot_marker.add_child(muzzle)
		muzzle.set_color("ffb31b")
		var direction = player_pos - shoot_marker.global_position
		fire_projectile(STONE_SKULL_PROJECTILE, shoot_marker.global_position, direction)
	shoot_time.start()

func fire_projectile(proj: PackedScene, pos: Vector3, direction: Vector3):
	var p = proj.instantiate()
	p.damage = projectile_damage
	p.speed = projectile_speed
	p.range = projectile_range
	get_tree().current_scene.add_child(p)
	p.global_position = pos
	p.set_linear_velocity(direction * projectile_speed)

func target_position(target):
	player_pos = target
