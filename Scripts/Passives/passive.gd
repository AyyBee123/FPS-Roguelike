class_name Passive extends Node

@export var stat_name: String
@export var stats: Array[StatType]

var stats_to_give: Array[StatType]

var rarity_weights: Dictionary = { # 0 = COMMON, 1 = UNCOMMON, 2 = LEGENDARY, 3 = HYBRID
	0: 70,
	1: 19,
	2: 1,
	3: 10
}

var rarity: int = 0

func _init():
	randomize()
	set_rarity()

func _ready():
	get_rarity()

func set_rarity():
	# convert to cumulative drop chances
	var total_weight := 0.0
	for weight in rarity_weights.values():
		total_weight += weight
	
	var weighted_amount = randf() * total_weight
	
	# find which rarity it falls into
	var cumulative: float = 0.0
	for r in rarity_weights.keys():
		cumulative += rarity_weights[r]
		if weighted_amount <= cumulative:
			rarity = r
			break

func get_rarity():
	for stat in stats:
		if stat.rarity == rarity:
			stats_to_give.append(stat)

func add_stats(player):
	for stat in stats_to_give:
		match stat.type:
			"+":
				player.stats.add_percent_stat(stat.stat, stat.amount)
			"x":
				player.stats.multiply_stat(stat.stat, stat.amount)
			"flat":
				player.stats.add_flat_stat(stat.stat, stat.amount)
