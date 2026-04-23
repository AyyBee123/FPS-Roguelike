extends Node3D

@export var INK: PackedScene
@export var SOUND: AudioStream

@onready var laser = %Laser
@onready var vfx = %VFX
@onready var collision_shape_3d = %CollisionShape3D
@onready var outer_beam = %"Outer Beam"
@onready var beam = %Beam
@onready var lines = %Lines
@onready var muzzle_end = %MuzzleEnd
@onready var ray_cast = %RayCast3D
@onready var size = vfx.scale

const DRAW_DAMAGE_MULTIPLIER: float = 30

var blot: Arm
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

var trail_points: Array[Decal]
var close_threshold: float = 0.8  # minimum distance to a point to close the shape
var min_points_threshold: int = 20 # minimum difference between indeces in trail_points
var max_length: float = 0.2
var is_drawing: bool = true
var new_point_added: bool = false
var level: Level
var frame_count: int = 0

func _ready():
	level = GameState.current_level
	vfx.scale.x = 0
	vfx.scale.y = 0
	tween = get_tree().create_tween()
	tween.tween_property(vfx, "scale", size, 0.2)
	adjust_length()

func _physics_process(delta):
	if not blot:
		shrink()
		return
	
	damage = blot.damage
	range = blot.range
	tick_rate = 1.0 / (blot.fire_rate * TICK_MULTIPLIER)
	
	var camera_direction = (blot.get_camera_point(range) - get_global_transform().origin).normalized()
	look_at(global_transform.origin + camera_direction, Vector3.UP)
	adjust_length()
	
	damage_timer += delta
	if damage_timer >= tick_rate and enemies.size() > 0:
		damage_timer = 0.0
		for enemy in enemies:
			enemy.hit(damage, player, self)
	
	frame_count += 1
	
	if trail_points.size() > min_points_threshold and new_point_added:
		new_point_added = false
		if frame_count % 3 == 0:
			check_shape_closed(trail_points[-1].global_position, trail_points.size() - 1)

func adjust_length():
	ray_cast.target_position.z = range
	if ray_cast.get_collider():
		var collision_point = ray_cast.get_collision_point()
		beam.scale.z = min(ray_cast.target_position.z / 2, ray_cast.global_position.distance_to(collision_point))
		muzzle_end.position.z = ray_cast.global_position.distance_to(collision_point)
		draw_ink(collision_point, ray_cast.get_collision_normal())
	else:
		beam.scale.z = ray_cast.target_position.z / 2
		muzzle_end.position.z = range
	beam.scale.z = max(beam.scale.z, 1)
	outer_beam.scale.z = beam.scale.z
	lines.lifetime = max((beam.scale.z * 2 - 0.5) / lines.process_material.initial_velocity.length(), 0.01)
	
	collision_shape_3d.shape.height = beam.scale.z * 2
	collision_shape_3d.position.z = beam.scale.z

func draw_ink(collision_point: Vector3, normal: Vector3):
	if not is_drawing: return
	
	if trail_points.is_empty():
		add_ink(collision_point, normal)
		return
	
	var last_pos: Vector3 = trail_points[-1].global_position
	var last_normal: Vector3 = trail_points[-1].basis.y
	
	var distance: float = last_pos.distance_to(collision_point)
	
	if distance > max_length:
		# subdivide points
		var steps: int = ceili(distance / max_length)
		for i in range(1, steps + 1):
			var t: float = float(i) / float(steps)
			var interp: Vector3 = last_pos.lerp(collision_point, t)
			var interp_normal: Vector3 = last_normal.lerp(normal, t).normalized()
			add_ink(interp, interp_normal)

func add_ink(point, normal):
	var ink = INK.instantiate()
	ink.laser = self
	trail_points.append(ink)
	level.add_child(ink)
	
	var up: Vector3 = normal.normalized()
	var ref: Vector3 = Vector3.FORWARD if abs(normal.dot(Vector3.FORWARD)) < 0.9 else Vector3.RIGHT
	var right: Vector3 = up.cross(ref).normalized()
	var forward: Vector3 = right.cross(up).normalized()
	
	ink.global_transform.basis = Basis(right, up, -forward)
	ink.global_position = point
	
	new_point_added = true

func check_shape_closed(current_pos: Vector3, current_index: int):
	var max_check_index: float = current_index - min_points_threshold
	
	if max_check_index <= 0: return
	
	for i in range(max_check_index):
		if current_pos.distance_to(trail_points[i].global_position) < close_threshold:
			on_shape_closed(i)
			return

func on_shape_closed(loop_start_index: int):
	# Build polygon from the closed loop slice only
	var shape_slice: Array[Decal] = trail_points.slice(loop_start_index)
	var polygon_2d: PackedVector2Array = PackedVector2Array()
	for decal in shape_slice:
		polygon_2d.append(Vector2(decal.global_position.x, decal.global_position.z))

	# Damage enemies inside
	for enemy in Enemy.all:
		var ep: Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
		if Geometry2D.is_point_in_polygon(ep, polygon_2d):
			enemy.hit(damage * DRAW_DAMAGE_MULTIPLIER, player, self)
	spawn_shape_mesh(shape_slice, polygon_2d)
	
	for i in trail_points:
		if i:
			i.queue_free()
	shrink()

func shrink():
	if blot:
		blot.animation_player.play("Shoot to Idle")
	for i in trail_points:
		if i:
			i.quick_fade_out()
	is_drawing = false
	collision_shape_3d.disabled = true
	tween = get_tree().create_tween()
	tween.tween_property(vfx, "scale:x", 0, 0.25)
	tween.parallel().tween_property(vfx, "scale:y", 0, 0.25)
	tween.tween_callback(queue_free)
	

func _on_laser_body_entered(body):
	if not body is Enemy:
		return
	if not body.has_meta("ink_laser_overlap"):
		body.set_meta("ink_laser_overlap", [])
	body.get_meta("ink_laser_overlap").append(self)
	enemies.append(body)

func _on_laser_body_exited(body):
	if not body is Enemy:
		return
	if body.has_meta("ink_laser_overlap"):
		body.get_meta("ink_laser_overlap", []).erase(self)
	enemies.erase(body)

func ensure_counter_clockwise(polygon: PackedVector2Array) -> PackedVector2Array:
	# calculate signed area (negative = clockwise)
	var signed_area: float = 0.0
	for i in range(polygon.size()):
		var a: Vector2 = polygon[i]
		var b: Vector2 = polygon[(i + 1) % polygon.size()]
		signed_area += (b.x - a.x) * (b.y + a.y)
	
	if signed_area > 0:
		var reversed: PackedVector2Array = PackedVector2Array(polygon)
		reversed.reverse()
		return reversed
	return polygon

func spawn_shape_mesh(shape_slice: Array, polygon_2d: PackedVector2Array) -> void:
	polygon_2d = ensure_counter_clockwise(polygon_2d)
	var indices: PackedInt32Array = Geometry2D.triangulate_polygon(polygon_2d)
	
	# fallback to convex hull if triangulation fails
	if indices.is_empty() or indices.size() != (polygon_2d.size() - 2) * 3:
		polygon_2d = Geometry2D.convex_hull(polygon_2d)
		polygon_2d = ensure_counter_clockwise(polygon_2d)
		indices = Geometry2D.triangulate_polygon(polygon_2d)
		
		# rebuild shape_slice to match the new hull points
		# map hull points back to nearest original decals
		var hull_slice: Array = []
		for hull_point in polygon_2d:
			var closest: Node3D = shape_slice[0]
			var closest_dist: float = INF
			for decal in shape_slice:
				var d: float = Vector2(decal.global_position.x, decal.global_position.z).distance_to(hull_point)
				if d < closest_dist:
					closest_dist = d
					closest = decal
			hull_slice.append(closest)
		shape_slice = hull_slice
	
	var extrude_height: float = 200.0  # how tall in Y
	
	var verts: PackedVector3Array = PackedVector3Array()
	var normals: PackedVector3Array= PackedVector3Array()
	var uvs: PackedVector2Array= PackedVector2Array()

	# --- TOP and BOTTOM faces ---
	for i in range(0, indices.size(), 3):
		var a: Vector3 = shape_slice[indices[i]].global_position
		var b: Vector3 = shape_slice[indices[i + 1]].global_position
		var c: Vector3 = shape_slice[indices[i + 2]].global_position

		# Bottom face (winding flipped)
		verts.append_array([a, c, b])
		normals.append_array([Vector3.DOWN, Vector3.DOWN, Vector3.DOWN])
		uvs.append_array([Vector2(a.x, a.z), Vector2(c.x, c.z), Vector2(b.x, b.z)])

		# Top face (offset up)
		var at: Vector3 = a + Vector3.UP * extrude_height
		var bt: Vector3 = b + Vector3.UP * extrude_height
		var ct: Vector3 = c + Vector3.UP * extrude_height
		verts.append_array([at, bt, ct])
		normals.append_array([Vector3.UP, Vector3.UP, Vector3.UP])
		uvs.append_array([Vector2(at.x, at.z), Vector2(bt.x, bt.z), Vector2(ct.x, ct.z)])

	var count: int = shape_slice.size()
	for i in range(count):
		var curr: Vector3 = shape_slice[i].global_position
		var next: Vector3 = shape_slice[(i + 1) % count].global_position

		var curr_top: Vector3 = curr + Vector3.UP * extrude_height
		var next_top: Vector3 = next + Vector3.UP * extrude_height

		# Outward normal for this wall segment
		var edge: Vector3 = (next - curr).normalized()
		var wall_normal: Vector3 = edge.cross(Vector3.UP).normalized()

		# Two triangles per side quad
		verts.append_array([curr, next, curr_top])
		verts.append_array([next, next_top, curr_top])
		normals.append_array([wall_normal, wall_normal, wall_normal,
							   wall_normal, wall_normal, wall_normal])

		var u_curr: float = float(i) / count
		var u_next: float = float(i + 1) / count
		uvs.append_array([
			Vector2(u_curr, 1), Vector2(u_next, 1), Vector2(u_curr, 0),
			Vector2(u_next, 1), Vector2(u_next, 0), Vector2(u_curr, 0)
		])

	var arr: Array = Array()
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_NORMAL] = normals
	arr[Mesh.ARRAY_TEX_UV] = uvs

	var mesh: ArrayMesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)

	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	var mat: ShaderMaterial = beam.material_override.duplicate()
	mesh_instance.material_override = mat
	get_tree().current_scene.add_child(mesh_instance)
	mesh_instance.global_position.y -= 100
	
	var tw: Tween = get_tree().create_tween()
	tw.tween_interval(0.2)
	tw.tween_method(func(v: float): mat.set_shader_parameter("opacity", v), 1.0, 0.0, 0.3)
	tw.tween_callback(mesh_instance.queue_free)
	
	play_sound_at_centroid(shape_slice, polygon_2d)

func play_sound_at_centroid(shape_slice: Array, polygon_2d: PackedVector2Array) -> void:
	# average all points to get the center
	var centroid: Vector3 = Vector3.ZERO
	for decal in shape_slice:
		centroid += decal.global_position
	centroid /= shape_slice.size()
	
	# calculate polygon area
	var area: float = 0.0
	for i in range(polygon_2d.size()):
		var a: Vector2 = polygon_2d[i]
		var b: Vector2 = polygon_2d[(i + 1) % polygon_2d.size()]
		area += a.x * b.y - b.x * a.y
	area = abs(area) * 0.5

	# larger shape = lower pitch, smaller shape = higher pitch
	var min_area: float = 1.0
	var max_area: float = 40.0
	var min_pitch: float = 2.0
	var max_pitch: float = 4.0

	var t: float = clamp(inverse_lerp(min_area, max_area, area), 0.0, 1.0)
	var pitch: float = lerp(max_pitch, min_pitch, t) # inverted, big = low pitch

	var audio: DeconflictedAudioPlayer = DeconflictedAudioPlayer.new()
	audio.stream = SOUND
	audio.pitch_scale = pitch
	audio.unit_size = 30.0
	audio.bus = &"SFX"
	get_tree().current_scene.add_child(audio)
	audio.global_position = centroid
	audio.play_deconflicted()
	audio.finished.connect(audio.queue_free)
