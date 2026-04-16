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

func set_projectile_flags(proj):
	proj.damage = damage
	proj.speed = speed
	proj.range = range
	proj.radius = splash_radius
	proj.player = player
	proj.color = ball.get_instance_shader_parameter("zippy_albedo")
