extends Area3D

@onready var enemy: Enemy = get_parent()

const SEPARATION_FORCE: float = 10.0
const MIN_DISTANCE: float = 1.0
const TICK_RATE: float = 0.06

var nearby_enemies: Array[Enemy]
var t: float = 0.0

func _ready():
	t = randf_range(TICK_RATE/2, TICK_RATE)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta):
	t += delta
	if t >= TICK_RATE:
		t = 0.0
		push(delta)

func push(delta):
	for e in nearby_enemies:
		if not is_instance_valid(e):
			continue
		
		var direction: Vector3 = enemy.global_position - e.global_position
		direction.y = 0.0
		
		var distance: float = direction.length_squared()
		distance = max(distance, 0.25) # prevents "launching" if enemies are too close to each other
		
		var weight_ratio: float = e.weight / enemy.weight
		
		enemy.global_position += direction.normalized() * (SEPARATION_FORCE / distance) * delta * weight_ratio

func _on_body_entered(body):
	if body == enemy:
		return
	nearby_enemies.append(body)

func _on_body_exited(body):
	nearby_enemies.erase(body)
