extends Arm

@onready var star = %Star
@onready var star_001 = %Star_001
@onready var star_002 = %Star_002
@onready var star_003 = %Star_003
@onready var star_barrel = %"Star Barrel"
@onready var marker = %Marker
@onready var marker_2 = %Marker2
@onready var marker_3 = %Marker3
@onready var marker_4 = %Marker4
@onready var crescent = %Crescent
@onready var barrel_marker = %"Barrel Marker"

const ROTATION_SPEED_MAX: float = 20.0
const STAR_BARREL_SPEED: float = 1.0

var STAR_ROTATION_SPEEDS: Array[float]
var STAR_SELF_ROTATION_SPEEDS: Array[float]

var stars: Array[MeshInstance3D]
var star_self_speeds: Array[float]
var star_markers: Array[Marker3D]
var star_speeds: Array[float]
var star_barrel_speed: float
var time: float

var sway_amount: float = 0.16
var max_sway: float = 6.0
var barrel_pos: Vector3

func _ready():
	super._ready()
	stars = [star, star_001, star_002, star_003]
	star_markers = [marker, marker_2, marker_3, marker_4]
	barrel_pos = barrel_marker.position
	
	var size = stars.size()
	STAR_ROTATION_SPEEDS.resize(size)
	STAR_SELF_ROTATION_SPEEDS.resize(size)
	star_self_speeds.resize(size)
	star_speeds.resize(size)
	
	for i in range(stars.size()):
		STAR_ROTATION_SPEEDS[i] = randf_range(0.8, 1.2) * (1.0 if randf() < 0.5 else -1.0)
		star_speeds[i] = STAR_ROTATION_SPEEDS[i]
		STAR_SELF_ROTATION_SPEEDS[i] = randf_range(2.0, 3.0) * -sign(STAR_ROTATION_SPEEDS[i])
		star_self_speeds[i] = STAR_SELF_ROTATION_SPEEDS[i]
		star_markers[i].rotation.y = randf_range(0, TAU)
	star_barrel_speed = STAR_BARREL_SPEED
	crescent.rotation.y = randf_range(0, TAU)

func _physics_process(delta):
	super._physics_process(delta)
	
	time += delta
	
	if player:
		barrel_marker.position.x = -min(player.camera_controller.rig.rotation.y, max_sway) * sway_amount + barrel_pos.x
		barrel_marker.position.z = min(player.camera_controller.rig.rotation.x, max_sway) * sway_amount + barrel_pos.z
	
	for i in range(stars.size()):
		star_speeds[i] = lerpf(star_speeds[i], STAR_ROTATION_SPEEDS[i], 0.08)
		star_self_speeds[i] = lerpf(star_self_speeds[i], STAR_SELF_ROTATION_SPEEDS[i], 0.08)
		star_markers[i].rotation.y += star_speeds[i] * delta
		stars[i].rotation.y += star_self_speeds[i] * delta
	
	star_barrel_speed = lerpf(star_barrel_speed, STAR_BARREL_SPEED, 0.05)
	crescent.rotation.y -= 0.8 * delta
	star_barrel.rotation.y += star_barrel_speed * delta
	star_barrel.position.z = sin(time * 1.2) * 0.02

func set_projectile_flags(proj):
	proj.target = bullet_point
	proj.damage = damage
	proj.speed = speed
	proj.range = range
	proj.radius = splash_radius
	proj.player = player
