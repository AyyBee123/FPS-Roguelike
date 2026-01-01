extends Node3D

@onready var passive = %Passive
@onready var mesh_instance = %MeshInstance
@onready var default_pos = mesh_instance.get_position()

const AMPLITUDE: float = 0.1
const FREQUENCY: float = 2.0

var time: float = 0.0
var item: Node

var rarity_weights = ItemPool.rarity_weights

func _ready():
	randomize()
	# Convert to cumulative drop chances
	var total_weight := 0.0
	for weight in rarity_weights.values():
		total_weight += weight
	
	var weighted_amount = randf() * total_weight
	
	# Find which rarity it falls into
	var cumulative: float = 0.0
	var chosen_rarity: int = -1
	for rarity in rarity_weights.keys():
		cumulative += rarity_weights[rarity]
		if weighted_amount <= cumulative:
			chosen_rarity = rarity
			break
	
	# Pick item from the correct pool
	var pool_name := ""
	match chosen_rarity:
		0: pool_name = "common_pool"
		1: pool_name = "uncommon_pool"
		2: pool_name = "legendary_pool"
	
	item = ItemPool.get(pool_name).pick_random().instantiate()
	
	mesh_instance.mesh = item.mesh
	passive.add_child(item)

func _physics_process(delta):
	rotate_y(PI/2 * delta)
	
	time += delta * FREQUENCY
	mesh_instance.set_position(default_pos + Vector3(0, sin(time) * AMPLITUDE, 0))

func pick_up(player):
	item.on_pick_up(player)
	passive.remove_child(item)
	player.passives.add_child(item)
	queue_free()
