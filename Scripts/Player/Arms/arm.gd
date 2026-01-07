class_name Arm extends Node3D

@export_enum("COMMON", "UNCOMMON", "LEGENDARY", "UNSET:-1") var rarity: int = -1

@export_category("Base Stats")
@export var projectile: PackedScene # the projectile shot by the arm
@export var base_damage: float # damage dealt by the projectile
@export var base_fire_rate: float # in shots per second
@export var base_range: float # the distance (in pixels) before the projectile disappears
@export var base_speed: float # velocity of the projectile shot by the arm
@export var base_splash_radius: float = 1.0 # the splash radius of splash effects from the arm
@export var base_projectile_count: int = 1 # number of projectiles shot from the arm at once

@export_category("Accuracy & Recoil")
@export var spread: float = 0.0 # the random spread amount of the projectile(s) in degrees
@export var recoil: Vector2 # amount of recoil created the arm rotates by when shot
@export var recoil_speed: float # speed in which the camera rotates
@export var snap: float # the speed in which the camera snaps back to its original rotation

@export_category("Miscellaneous")
@export var shoot_animation: String = "Shoot"
@export var equip_animation: String = "Activate"
@export var muzzle: PackedScene
@export var muzzle_color: Color = Color("fccf95")
@export var firing_audio: Array[DeconflictedAudioPlayer]

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var bullet_point: Marker3D = %"Bullet Point"

var player: Player # declared in the weapons manager script

var damage: float:
	get:
		return get_stat(base_damage, "Damage")
var fire_rate: float:
	get:
		return get_stat(base_fire_rate, "Fire_Rate")
var range: float:
	get:
		return get_stat(base_range, "Range")
var speed: float:
	get:
		return get_stat(base_speed, "Speed")
var splash_radius: float:
	get:
		return get_stat(base_splash_radius, "Splash_Radius")
var projectile_count: int:
	get:
		return get_stat(base_projectile_count, "Projectile_Count")

var fire_rate_timer: float = 0.0
var t: float = 0.0

const DEBUG_BULLET = preload("uid://btq2f4vqn8fhy")

func _ready():
	fire_rate_timer = 1.0 / fire_rate

func _physics_process(delta):
	t += delta

func shoot():
	if t < fire_rate_timer: return
	
	t = 0.0
	fire_rate_timer = 1.0 / fire_rate
	animation_player.stop()
	animation_player.play(shoot_animation)
	if muzzle:
		var m = muzzle.instantiate()
		m.set_color(muzzle_color)
		bullet_point.add_child(m)
	
	var camera_collision = get_camera_collision()
	
	player._on_arm_shot(self)
	
	for i in range(projectile_count):
		launch_projectile(camera_collision)
	
	for audio in firing_audio:
		if audio:
			audio.play_deconflicted()

func get_camera_collision() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_visible_rect().size
	
	var ray_origin = camera.project_ray_origin(viewport / 2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport / 2) * range
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	new_intersection.collision_mask = CollisionLayers.get_layer(["World", "Player"])
	
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty():
		return intersection.position
	else:
		return ray_end

func launch_projectile(point: Vector3):
	var spread_rad: float = deg_to_rad(spread)
	var direction = (point - bullet_point.get_global_transform().origin).normalized()
	var proj = projectile.instantiate()
	
	# get random angle in a uniform distribution
	var cos_angle = lerp(cos(spread_rad), 1.0, randf())
	var angle = acos(cos_angle)
	
	# get a random perpendicular axis
	var perp = direction.cross(Vector3.UP)
	if perp.length() < 0.001:
		perp = direction.cross(Vector3.RIGHT)
	perp = perp.rotated(direction, randf() * TAU).normalized()
	
	direction = direction.rotated(perp, angle)
	
	proj.damage = damage
	proj.speed = speed
	proj.range = range
	proj.player = player
	
	get_tree().current_scene.add_child(proj)
	player._on_arm_fired(proj, damage)
	
	proj.global_transform.origin = bullet_point.global_transform.origin
	proj.look_at(proj.global_transform.origin + direction, Vector3.UP)
	proj.set_linear_velocity(direction * speed)

func get_stat(stat: Variant, property: String) -> Variant:
	return stat if not player else stat * player.stats.get_stat(property)

#func hit_scan_collision(collision_point):
	#var bullet_direction = (collision_point - bullet_point.get_global_transform().origin).normalized()
	#var new_int = PhysicsRayQueryParameters3D.create(bullet_point.get_global_transform().origin, \
			#collision_point + bullet_direction * 2, CollisionLayers.get_layer(["Pickup"]))
	#
	#var bullet_collision = get_world_3d().direct_space_state.intersect_ray(new_int)
	#
	#if bullet_collision:
		#var hit_indicator = DEBUG_BULLET.instantiate()
		#var world = get_tree().current_scene
		#world.add_child(hit_indicator)
		#hit_indicator.global_translate(bullet_collision.position)
		#
		#var collider = bullet_collision.collider
		#if collider.is_in_group("Enemy") and collider.has_method("hit"):
			#collider.hit(damage)
