extends Node3D

@onready var area = %Area3D
@onready var beam: MeshInstance3D = %Beam
@onready var inner_beam: MeshInstance3D = %"Inner Beam"
@onready var outer_beam: MeshInstance3D = %"Outer Beam"
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

@onready var beam_radius: float = beam.scale.x
@onready var inner_beam_radius: float = inner_beam.scale.x
@onready var outer_beam_radius: float = outer_beam.scale.x

var target: RigidBody3D

var player: Player
var damage: float
var tick_rate: float
var enemies: Array[Enemy]

var frequency: float = 12.0
var amplitude: float = 0.01
var t: float = 0.0
var damage_timer: float = INF

func _ready():
	set_beam_length(0.05)

func _physics_process(delta):
	if not is_instance_valid(target):
		queue_free()
		return
	
	if global_position.distance_to(target.global_position) > 0.01:
		look_at(target.global_position)
	set_beam_length(global_position.distance_to(target.global_position))
	
	t += delta
	set_beam_radius(sin(t * frequency) * amplitude)
	
	damage_timer += delta
	if damage_timer >= tick_rate and enemies.size() > 0:
		damage_timer = 0.0
		for enemy in enemies:
			if is_primary_beam(enemy):
				enemy.hit(damage, player, self)

func set_beam_length(length: float):
	beam.scale.z = length / 2
	inner_beam.scale.z = length / 2
	outer_beam.scale.z = length / 2
	collision_shape_3d.shape.height = length
	collision_shape_3d.position.z = -length / 2

func set_beam_radius(radius: float):
	beam.scale.x = radius + beam_radius
	beam.scale.y = radius + beam_radius
	
	outer_beam.scale.x = radius + outer_beam_radius
	outer_beam.scale.y = radius + outer_beam_radius

func is_primary_beam(enemy) -> bool:
	var overlapping = enemy.get_meta("beams_overlapping", [])
	return overlapping.is_empty() or overlapping[0] == self

func _on_area_3d_body_entered(body):
	if not body is Enemy:
		return
	if not body.has_meta("beams_overlapping"):
		body.set_meta("beams_overlapping", [])
	body.get_meta("beams_overlapping").append(self)
	enemies.append(body)

func _on_area_3d_body_exited(body):
	if not body is Enemy:
		return
	if body.has_meta("beams_overlapping"):
		body.get_meta("beams_overlapping", []).erase(self)
	enemies.erase(body)
