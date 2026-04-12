extends Node

signal repopulate_done

var rarity_weights: Dictionary = { # 0 = COMMON, 1 = UNCOMMON, 2 = LEGENDARY
	0: 78,
	1: 20,
	2: 2
}

var common_pool: Array[PackedScene] = []
var uncommon_pool: Array[PackedScene] = []
var legendary_pool: Array[PackedScene] = []

var filled_common_pool: Array[PackedScene] = []
var filled_uncommon_pool: Array[PackedScene] = []
var filled_legendary_pool: Array[PackedScene] = []

var json_file: String = "res://Data/arm_pool.json"

func _init() -> void:
	# populate the arm pools
	populate_pool(common_pool, 0)
	populate_pool(uncommon_pool, 1)
	populate_pool(legendary_pool, 2)
	populate_pool(filled_common_pool, 0)
	populate_pool(filled_uncommon_pool, 1)
	populate_pool(filled_legendary_pool, 2)

func populate_pool(pool: Array, rarity: int):
	var loader = PoolLoader.new()
	loader.load_pool(json_file, pool, rarity)

func repopulate_pool(pool: Array, filled_pool: Array):
	pool.assign(filled_pool)

func roll(weights: Dictionary = rarity_weights) -> Arm:
	# Convert to cumulative drop chances
	var total_weight: float = 0.0
	for weight in weights.values():
		total_weight += weight
	
	var weighted_amount = randf() * total_weight
	
	# find which rarity it falls into
	var cumulative: float = 0.0
	var chosen_rarity: int = -1
	for rarity in weights.keys():
		cumulative += weights[rarity]
		if weighted_amount <= cumulative:
			chosen_rarity = rarity
			break
	
	# pick arm from the correct pool
	var pool_name: String = ""
	match chosen_rarity:
		0: pool_name = "common_pool"
		1: pool_name = "uncommon_pool"
		2: pool_name = "legendary_pool"
	
	if get(pool_name).is_empty():
		repopulate_pool(get(pool_name), get("filled_" + pool_name))
	
	var packed: PackedScene = get(pool_name).pick_random()
	var selected = packed.instantiate()
	get(pool_name).erase(packed)
	
	return selected
