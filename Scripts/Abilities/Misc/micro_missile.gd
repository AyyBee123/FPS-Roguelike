extends RigidBody3D

@onready var gpu_trail_3d: GPUTrail3D = $GPUTrail3D
@onready var trail_length: int = gpu_trail_3d.length

const MICRO_MISSILE_BLAST = preload("uid://d2rqsv85ki5y3")

const TIME_BEFORE_HOMING: float = 0.5
const ROTATIONAL_OFFSET: Vector3 = Vector3.RIGHT * 0.001 # offset to prevent direct upward rotation (can cause issues)

var damage: float
var speed: float

var rotational_acceleration: float = 8.0
var t: float
var enemy: Enemy
var player: Player

func _ready():
	look_at(global_transform.origin + Vector3.UP + ROTATIONAL_OFFSET)

func _physics_process(delta):
	look_at(global_transform.origin + linear_velocity + ROTATIONAL_OFFSET)
	
	t += delta
	if t > TIME_BEFORE_HOMING:
		if not is_instance_valid(enemy):
			enemy = get_enemy()
	
	if enemy:
		var desired_direction = (enemy.global_position - global_position).normalized() * speed
		linear_velocity = linear_velocity.lerp(desired_direction, rotational_acceleration * delta)

func get_enemy():
	if get_tree().get_nodes_in_group("Enemy").size() == 0:
		return null
	return get_tree().get_nodes_in_group("Enemy").pick_random()

func explode():
	var blast = MICRO_MISSILE_BLAST.instantiate()
	blast.position = position
	blast.scale = scale
	get_tree().current_scene.add_child(blast)
	queue_free()

func _on_body_entered(body):
	if body is Enemy:
		body.hit(damage, player, self)
	explode()

func _on_lifetime_timeout():
	explode()

func _on_visible_on_screen_notifier_3d_screen_entered():
	gpu_trail_3d.length = trail_length

func _on_visible_on_screen_notifier_3d_screen_exited():
	gpu_trail_3d.emitting = 0
