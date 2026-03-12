extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var BLAST: PackedScene
@export var BEAM: PackedScene

const MAX_AMOUNT: int = 10

static var emb_projectiles: Array[RigidBody3D]

var stuck: bool = false
var stuck_to: Node3D = null
var stuck_offset: Transform3D
var stuck_lifetime: float = 8.0
var tick_rate: float = 0.25
var damage_timer: float = INF

var enemy: Enemy
var tick_nodes: Array[Node]

func _ready():
	super._ready()
	
	# create the beams connecting each projectile
	for proj in emb_projectiles:
		if proj == self:
			continue
		var beam = BEAM.instantiate()
		beam.player = player
		beam.damage = damage
		beam.tick_rate = tick_rate
		beam.target = proj
		add_child(beam)
	
	emb_projectiles.append(self)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if stuck:
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
		if stuck_to and is_instance_valid(stuck_to):
			state.transform = stuck_to.global_transform * stuck_offset
		return
	var vel = state.linear_velocity
	
	if vel.length() > 0.01:
		var dir = vel.normalized()
		var up = Vector3.UP if abs(dir.dot(Vector3.UP)) < 0.99 else Vector3.RIGHT
		state.transform = Transform3D(Basis.looking_at(dir, up), state.transform.origin)

func _physics_process(delta):
	super._physics_process(delta)
	if stuck and not is_instance_valid(stuck_to):
		queue_free()
		return
	if emb_projectiles.size() > MAX_AMOUNT:
		if self == emb_projectiles[0]:
			queue_free()
	
	damage_timer += delta
	if damage_timer >= tick_rate and enemy:
		damage_timer = 0.0
		if enemy and is_primary_beam(enemy):
			enemy.hit(damage, player, self)

func _on_body_entered(body):
	if stuck: return
	stuck = true
	
	if body is Enemy:
		if not body.has_meta("mines_overlapping"):
			body.set_meta("mines_overlapping", [])
		body.get_meta("mines_overlapping").append(self)
		enemy = body
	
	stick_to(body)

func stick_to(target: Node):
	freeze = true
	stuck_to = target
	stuck_offset = target.global_transform.affine_inverse() * global_transform
	range = INF
	lifetime.start(stuck_lifetime)

func is_primary_beam(_enemy) -> bool:
	var overlapping = _enemy.get_meta("mines_overlapping", [])
	return overlapping.is_empty() or overlapping[0] == self

func explode():
	var blast = BLAST.instantiate()
	blast.damage = damage
	blast.radius = radius
	blast.player = player
	blast.color = "00ffff"
	blast.position = position
	get_tree().current_scene.add_child.call_deferred(blast)

func _exit_tree():
	emb_projectiles.erase(self)
	explode()
