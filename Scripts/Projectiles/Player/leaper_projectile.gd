extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var NUMBER_OF_BOUNCES: int = 1

@onready var mesh = %Mesh

var ignored: Array = [] # start by ignoring the enemy that was hit
var bounce_count: int = 0
var target: Enemy
var is_big_shot: bool = false

func _ready():
	super._ready()
	if is_big_shot:
		damage *= 2
		%Mesh.scale = Vector3.ONE * 0.4
		NUMBER_OF_BOUNCES = 2

func _physics_process(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		set_linear_velocity(direction * speed)

func _on_body_entered(body):
	if ignored.has(body):
		return
	if body is Enemy:
		body.hit(damage, player, self)
		if bounce_count < NUMBER_OF_BOUNCES:
			bounce(body)
		else:
			queue_free()
	else:
		create_impact()
		queue_free()

func bounce(enemy: Enemy):
	ignored.append(enemy)
	var _target: Enemy = get_closest_enemy(enemy, ignored, range / 2)
	if _target:
		var direction: Vector3 = _target.global_position - enemy.global_position
		lifetime.start()
		bounce_count += 1
		target = _target
		damage /= 2
		set_collision_mask_value(CollisionLayers.get_layer(["World"]), false)
		global_position = enemy.global_position
		look_at(global_position + direction, Vector3.UP)
	else:
		queue_free()

func get_closest_enemy(origin: Enemy, ignore: Array, max_range: float = INF) -> Enemy:
	var closest: Enemy = null
	var closest_dist = max_range
	
	var space_state = origin.get_world_3d().direct_space_state  # use get_world_3d() if 3D
	
	for enemy in get_tree().current_scene.get_children():
		if not enemy is Enemy: continue
		if enemy in ignore: continue
		
		var dist = origin.global_position.distance_to(enemy.global_position)
		if dist >= closest_dist: continue
		
		# Line of sight check
		var query = PhysicsRayQueryParameters3D.create(
			origin.global_position,
			enemy.global_position,
			CollisionLayers.get_layer(["World"]), # collision mask (just the world layer)
			[origin] # exclude the origin enemy from hitting itself
		)
		var result = space_state.intersect_ray(query)
		
		# if nothing was hit, or what was hit IS the target enemy
		if result.is_empty() or result.collider == enemy:
			closest_dist = dist
			closest = enemy
	
	return closest
