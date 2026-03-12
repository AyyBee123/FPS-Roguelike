extends Arm

@export var light_color: Color = "43e4e7"
@export var dim_color: Color = "1e6466"

@onready var beam = %Beam
@onready var beam_2 = %Beam2
@onready var sphere = %Sphere
@onready var arm = %Arm
@onready var barrel = %Barrel

var color_tween: Tween
var sphere_pos: Vector3
var sway_amount: float = 0.05
var max_sway: float = 8.0

func _ready():
	super._ready()
	set_shader_color(dim_color)
	sphere_pos = sphere.position

func _physics_process(delta):
	super._physics_process(delta)
	if player:
		sphere.position.x = -min(player.camera_controller.rig.rotation.y, max_sway) * sway_amount + sphere_pos.x
		sphere.position.z = min(player.camera_controller.rig.rotation.x, max_sway) * sway_amount + sphere_pos.z

func set_shader_color(color: Color):
	barrel.set_instance_shader_parameter("albedo_color", color)
	arm.set_instance_shader_parameter("albedo_color", color)

func _on_animation_player_animation_started(anim_name):
	if anim_name == "Shoot":
		color_tween = get_tree().create_tween()
		color_tween.bind_node(self)
		color_tween.tween_method(set_shader_color, dim_color, light_color, 0.05)
		color_tween.tween_interval(0.05)
		color_tween.tween_method(set_shader_color, light_color, dim_color, 0.25)
