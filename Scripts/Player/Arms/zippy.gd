extends Arm

@onready var index = %Index
@onready var middle = %Middle
@onready var pinky = %Pinky
@onready var ring = %Ring
@onready var thumb = %Thumb
@onready var ball = %Ball

var colors: Array[Color]

func _ready():
	colors.append(index.mesh.surface_get_material(0).albedo_color)
	colors.append(middle.mesh.surface_get_material(0).albedo_color)
	colors.append(pinky.mesh.surface_get_material(0).albedo_color)
	colors.append(ring.mesh.surface_get_material(0).albedo_color)
	colors.append(thumb.mesh.surface_get_material(0).albedo_color)
	change_ball_color()

func change_ball_color():
	ball.set_instance_shader_parameter("zippy_albedo", colors.pick_random())

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
	proj.radius = splash_radius
	proj.player = player
	proj.color = ball.get_instance_shader_parameter("zippy_albedo")
	
	Utils.copy_groups(self, proj)
	
	get_tree().current_scene.add_child(proj)
	player._on_arm_fired(proj, damage)
	
	proj.global_transform.origin = bullet_point.global_transform.origin
	proj.look_at(proj.global_transform.origin + direction, Vector3.UP)
	proj.set_linear_velocity(direction * speed)
