extends Node

var rarity_weights: Dictionary = { # 0 = COMMON, 1 = UNCOMMON, 2 = LEGENDARY
	0: 78,
	1: 20,
	2: 2
}

var common_pool: Array[PackedScene] = []
var uncommon_pool: Array[PackedScene] = []
var legendary_pool: Array[PackedScene] = []

var json_file: String = "res://Data/item_pool.json"

func _init() -> void:
	# populate the item pools
	populate_pool(common_pool, 0)
	populate_pool(uncommon_pool, 1)
	populate_pool(legendary_pool, 2)

func populate_pool(pool, rarity):
	var loader = PoolLoader.new()
	loader.load_pool(json_file, pool, rarity)

func roll(weights: Dictionary = rarity_weights) -> Item:
	# convert to cumulative drop chances
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
	
	# pick item from the correct pool
	var pool_name: String = ""
	match chosen_rarity:
		0: pool_name = "common_pool"
		1: pool_name = "uncommon_pool"
		2: pool_name = "legendary_pool"
	
	if get(pool_name).is_empty():
		if common_pool.is_empty() and uncommon_pool.is_empty() and legendary_pool.is_empty():
			return null
		else:
			return roll(weights)
	
	return get(pool_name).pick_random().instantiate()
