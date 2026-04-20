extends Node3D

@onready var mesh = %Mesh
@onready var collision_shape_3d = %CollisionShape3D

var player: Player
var ability: Ability

var enemies: Array[Enemy]
var damage_timer: float = INF
var added_damage: float = 0.0

func _ready():
	var radius = ability.get_stat_value("Range")
	mesh.scale = Vector3(1, 0, 1) * radius + Vector3.UP
	collision_shape_3d.shape.radius = radius
	collision_shape_3d.shape.height = radius * 2.5
	player.weapon_shot.connect(add_damage)

func _physics_process(delta):
	if not ability:
		queue_free()
		return
	
	var radius = ability.get_stat_value("Range")
	if player and collision_shape_3d.shape.radius != radius:
		mesh.scale = Vector3(1, 0, 1) * radius + Vector3.UP
		collision_shape_3d.shape.radius = radius
	
	damage_timer += delta
	if damage_timer >= 1.0 / ability.get_stat_value("Fire_Rate") and enemies.size() > 0:
		damage_timer = 0.0
		for enemy in enemies:
			enemy.hit(ability.get_stat_value("Damage") + added_damage, player, self)
	
	added_damage = max(added_damage * (1 - (delta * 2)), 0)

func add_damage(arm: Arm, source: Variant):
	if source != arm: return
	if arm == null: return
	
	added_damage += (arm.damage * arm.projectile_count) / 2.0

func _on_area_3d_body_entered(body):
	if not body is Enemy:
		return
	if not body.has_meta("heat_wave_overlap"):
		body.set_meta("heat_wave_overlap", [])
	body.get_meta("heat_wave_overlap").append(self)
	enemies.append(body)

func _on_area_3d_body_exited(body):
	if not body is Enemy:
		return
	if body.has_meta("heat_wave_overlap"):
		body.get_meta("heat_wave_overlap", []).erase(self)
	enemies.erase(body)
