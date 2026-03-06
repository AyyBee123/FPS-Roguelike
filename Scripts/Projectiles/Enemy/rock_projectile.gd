extends "res://Scripts/Projectiles/Enemy/enemy_projectile.gd"

@onready var raycast = %RayCast3D
@onready var mesh = %Mesh

const OFFSET: float = 2

func _physics_process(delta):
	t += delta
	if t >= TICK_RATE:
		t = 0.0
		global_position.x += direction.x * speed * delta
		global_position.z += direction.z * speed * delta
		global_position.y = lerp(global_position.y, raycast.get_collision_point().y + OFFSET, delta * gravity * 2)
		
		var move_vec = Vector3(direction.x, 0.0, direction.z) * speed * delta
		var distance = move_vec.length()
		
		if distance > 0.001:
			var roll_axis = Vector3.UP.cross(move_vec.normalized())
			var roll_angle = distance / 2
			mesh.rotate(roll_axis, roll_angle)
