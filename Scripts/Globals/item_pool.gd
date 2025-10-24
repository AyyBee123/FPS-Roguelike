extends Node

var rarity_weights: Dictionary = { # 0 = COMMON, 1 = RARE, 2 = LEGENDARY
	0: 78,
	1: 20,
	2: 2
}

var common_pool: Array[PackedScene] = []
var rare_pool: Array[PackedScene] = []
var legendary_pool: Array[PackedScene] = []

var json_file: String = "res://Data/item_pool.json"

func _init() -> void:
	# populate the item pools
	populate_pool(common_pool, 0)
	populate_pool(rare_pool, 1)
	populate_pool(legendary_pool, 2)

func populate_pool(pool, rarity):
	var loader = PoolLoader.new()
	loader.load_pool(json_file, pool, rarity)
