extends Area3D

@onready var enemy: Enemy = get_parent()

const SEPARATION_FORCE: float = 1.0
const MIN_DISTANCE: float = 1.0

var nearby_enemies: Array[Enemy]

func _physics_process(delta):
	for e in nearby_enemies:
		if not is_instance_valid(e):
			continue
		
		var direction: Vector3 = enemy.global_position - e.global_position
		direction.y = 0.0
		
		var distance: float = direction.length_squared()
		distance = max(distance, 0.25) # prevents "launching" if enemies are too close to each other
		
		var weight_ratio: float = e.weight / enemy.weight
		
		if distance < MIN_DISTANCE:
			enemy.velocity += direction.normalized() * (SEPARATION_FORCE / distance) * delta * weight_ratio

func _on_body_entered(body):
	if body == enemy:
		return
	nearby_enemies.append(body)

func _on_body_exited(body):
	nearby_enemies.erase(body)
