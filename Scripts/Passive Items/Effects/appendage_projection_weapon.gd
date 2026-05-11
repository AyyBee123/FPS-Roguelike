extends Node3D

var player: Player

@onready var arm_node = %"Arm Node"

const APPENDAGE_PROJECTION = preload("uid://i6ujlfa4dmcl")

const FREQUENCY: float = 0.002
const AMPLITUDE: float = 0.05

var arm: Arm
var tween: Tween
var pos: Vector3
var ability: Ability

var base_damage: float # damage dealt by the projectile
var base_fire_rate: float # in shots per second
var base_range: float # the distance (in pixels) before the projectile disappears
var base_speed: float # velocity of the projectile shot by the arm

func _ready():
	await get_tree().physics_frame
	var arm_scene = player.weapons_manager.current_arm.duplicate()
	var arm_mesh_list = arm_scene.find_children("", "MeshInstance3D", true)
	for mesh in arm_mesh_list:
		make_unique(mesh)
	if arm_scene.get_parent():
		arm_scene.get_parent().remove_child(arm_scene)
	%"Arm Node".add_child(arm_scene)
	
	arm = arm_scene
	set_material_override()
	arm.recoil = Vector2.ZERO
	arm.player = player
	set_base_stats()
	arm.add_to_group("Appendage Projection")
	for audio: DeconflictedAudioPlayer in arm.find_children("", "DeconflictedAudioPlayer", true):
		audio.volume_db = -28
		audio.max_db = 0
	player.weapon_shot.connect(shoot)
	player.weapon_released.connect(release)
	pos = arm_node.position
	if arm.muzzle:
		arm.muzzle.queue_free()

func _physics_process(_delta):
	if not ability:
		queue_free()
	
	arm.base_damage = base_damage * ability.get_base_stat_value("Damage")
	arm.base_fire_rate = base_fire_rate * ability.get_base_stat_value("Fire_Rate") + base_fire_rate / 8
	arm.base_range = base_range * ability.get_base_stat_value("Range")
	arm.base_speed = base_speed * ability.get_base_stat_value("Speed")

func _process(delta):
	arm_node.position.y = lerp(arm_node.position.y, sin(Time.get_ticks_msec() * FREQUENCY) * AMPLITUDE + pos.y, 5 * delta)

func set_base_stats():
	base_damage = arm.base_damage
	base_fire_rate = arm.base_fire_rate
	base_range = arm.base_range
	base_speed = arm.base_speed

func shoot(_arm: Arm):
	await get_tree().create_timer(1.0 / (arm.fire_rate * 8)).timeout
	if arm and not _arm.is_in_group("Appendage Projection"):
		arm.shoot()

func release(_arm: Arm):
	await get_tree().physics_frame
	if arm and not _arm.is_in_group("Appendage Projection"):
		arm.release()

func set_material_override():
	var mesh_instances: Array = arm.find_children("", "MeshInstance3D", true)
	for mesh_node: MeshInstance3D in mesh_instances:
		if mesh_node.mesh == null:
			continue
		mesh_node.material_override = APPENDAGE_PROJECTION

func make_unique(node: Node) -> void:
	if node is MeshInstance3D:
		# make the mesh resource unique first
		if node.mesh:
			node.mesh = node.mesh.duplicate(true)
		
		for i in node.get_surface_override_material_count():
			var mat = node.get_active_material(i)
			if mat:
				node.set_surface_override_material(i, mat.duplicate(true)) # deep copy
		
		if node.material_override:
			node.material_override = node.material_override.duplicate(true)
