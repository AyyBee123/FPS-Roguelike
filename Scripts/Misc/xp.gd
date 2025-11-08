extends Area3D

@onready var ray_cast = %RayCast
@onready var mesh = %MeshInstance3D

@export var xp_amount: int = 1
var player = null

func _ready():
	match xp_amount:
		1:
			mesh.material_override.albedo_color = "0092b8"
		2:
			mesh.material_override.albedo_color = "009e58"
		3:
			mesh.material_override.albedo_color = "e8b52e"
		4:
			mesh.material_override.albedo_color = "aa222d"
		_: # 5 or more
			mesh.material_override.albedo_color = "5e2bba"
	position.y = ray_cast.get_collision_point().y + 1

func _physics_process(delta):
	if player:
		position += (player.position - position) * delta * 10

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.gain_xp(xp_amount)
		queue_free()
