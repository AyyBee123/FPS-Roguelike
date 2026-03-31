extends RigidBody3D

@onready var camera = %Camera3D
@onready var timer = %Timer
@onready var death = %Death

var player: Player

func _ready():
	death.play_deconflicted()
	camera.current = true
	camera.fov = player.camera.fov
	
	linear_velocity = player.velocity * 2
	angular_velocity = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))

func _physics_process(delta):
	linear_velocity = linear_velocity.lerp(Vector3.ZERO, 1.0 * delta)
	angular_velocity = angular_velocity.lerp(Vector3.ZERO, 2.0 * delta)

func _on_timer_timeout():
	player.open_death_menu()
