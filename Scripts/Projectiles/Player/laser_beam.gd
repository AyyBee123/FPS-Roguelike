extends Node3D

@onready var laser = %Laser
@onready var vfx = %VFX
@onready var collision_shape_3d = %CollisionShape3D
@onready var outer_beam = %"Outer Beam"
@onready var beam = %Beam
@onready var lines = %Lines
@onready var muzzle_end = %MuzzleEnd
@onready var ray_cast = %RayCast3D
@onready var size = vfx.scale

var mornstar: Arm
var player: Player

var damage: float
var speed: float
var range: float
var tick_rate: float

var direction: Vector3
var tween: Tween

var enemies: Array[Enemy]
var damage_timer: float = INF
var TICK_MULTIPLIER: float

func _ready():
	vfx.scale.x = 0
	vfx.scale.y = 0
	tween = get_tree().create_tween()
	tween.tween_property(vfx, "scale", size, 0.2)
	adjust_length()

func _physics_process(delta):
	if not mornstar:
		shrink()
		return
	
	damage = mornstar.damage
	range = mornstar.range
	tick_rate = 1.0 / (mornstar.fire_rate * TICK_MULTIPLIER)
	
	var camera_direction = (mornstar.get_camera_point(range) - get_global_transform().origin).normalized()
	look_at(global_transform.origin + camera_direction, Vector3.UP)
	adjust_length()
	
	damage_timer += delta
	if damage_timer >= tick_rate and enemies.size() > 0:
		damage_timer = 0.0
		for enemy in enemies:
			enemy.hit(damage, player, self)

func adjust_length():
	ray_cast.target_position.z = range
	if ray_cast.get_collider():
		var collision_point = ray_cast.get_collision_point()
		beam.scale.z = min(ray_cast.target_position.z / 2, ray_cast.global_position.distance_to(collision_point))
		muzzle_end.position.z = ray_cast.global_position.distance_to(collision_point)
	else:
		beam.scale.z = ray_cast.target_position.z / 2
		muzzle_end.position.z = range
	beam.scale.z = max(beam.scale.z, 1)
	outer_beam.scale.z = beam.scale.z
	lines.lifetime = max((beam.scale.z * 2 - 0.5) / lines.process_material.initial_velocity.length(), 0.01)
	
	collision_shape_3d.shape.height = beam.scale.z * 2
	collision_shape_3d.position.z = beam.scale.z

func shrink():
	collision_shape_3d.disabled = true
	tween = get_tree().create_tween()
	tween.tween_property(vfx, "scale:x", 0, 0.25)
	tween.parallel().tween_property(vfx, "scale:y", 0, 0.25)
	tween.tween_callback(queue_free)

func _on_laser_body_entered(body):
	if not body is Enemy:
		return
	if not body.has_meta("mornstar_laser_overlap"):
		body.set_meta("mornstar_laser_overlap", [])
	body.get_meta("mornstar_laser_overlap").append(self)
	enemies.append(body)

func _on_laser_body_exited(body):
	if not body is Enemy:
		return
	if body.has_meta("mornstar_laser_overlap"):
		body.get_meta("mornstar_laser_overlap", []).erase(self)
	enemies.erase(body)
