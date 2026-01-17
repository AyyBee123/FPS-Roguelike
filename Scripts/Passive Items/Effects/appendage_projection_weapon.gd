extends Node3D

@export var player: Player

@onready var arm_node = %"Arm Node"

const APPENDAGE_PROJECTION = preload("uid://i6ujlfa4dmcl")

const FREQUENCY: float = 0.001
const AMPLITUDE: float = 0.025

var arm: Arm
var tween: Tween
var pos: Vector3

func _ready():
	arm = arm_node.get_child(0)
	set_material_override()
	arm.recoil = Vector2.ZERO
	arm.player = player
	arm.add_to_group("Appendage Projection")
	for audio: DeconflictedAudioPlayer in arm.find_children("", "DeconflictedAudioPlayer", true):
		audio.volume_db = -28
		audio.max_db = 0
	player.enemy_hit.connect(shoot)
	pos = arm_node.position

func _process(delta):
	arm_node.position.y = lerp(arm_node.position.y, sin(Time.get_ticks_msec() * FREQUENCY) * AMPLITUDE + pos.y, 5 * delta)

func shoot(_enemy: Enemy, _source: Variant, _damage: float):
	if arm and not _source.is_in_group("Appendage Projection"):
		arm.shoot(false, self)
	
	tween = get_tree().create_tween()
	tween.tween_property(arm_node, "position:y", pos.y, 0.2)

func set_material_override():
	var mesh_instances: Array = arm.find_children("", "MeshInstance3D", true)
	
	for mesh_node: MeshInstance3D in mesh_instances:
		if mesh_node.mesh == null:
			continue
		
		mesh_node.material_override = APPENDAGE_PROJECTION
