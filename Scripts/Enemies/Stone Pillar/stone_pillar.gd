extends Boss

func _ready():
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	var dir: Vector3 = player.global_position - global_position
	var dist_sq: float = dir.length_squared()
	var vel: Vector3 = Vector3.ZERO
	
	if dist_sq > 0.001:
		vel = dir.rotated(Vector3.UP, %Armature.rotation.y) * speed / sqrt(dist_sq)
	
	rotation.y = lerp_angle(rotation.y, atan2(vel.x, vel.z), delta * angular_acceleration)

func set_spawned():
	SignalBus.boss_spawned.emit(self)
