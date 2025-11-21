class_name Ability extends Node

@export var icon: Texture
@export var ability_name: String
@export_multiline var description: String
@export var ability_upgrades: Array[AbilityUpgradeResource]

var common_upgrades: Array[AbilityUpgradeResource] = []
var uncommon_upgrades: Array[AbilityUpgradeResource] = []
var rare_upgrades: Array[AbilityUpgradeResource] = []
var legendary_upgrades: Array[AbilityUpgradeResource] = []

var upgrades: Array[AbilityUpgradeResource] = []
var upgrades_to_add: Array[AbilityUpgradeResource] = []

var player: Player

var ability_exists: bool = false # checks if the player already has the ability

# rarity weightings for ability upgrades
var rarity_weights: Dictionary = { # 0 = COMMON, 1 = UNCOMMON, 2 = LEGENDARY, 3 = RARE
	0: 70,
	1: 19,
	2: 1,
	3: 10
}

var chance_for_extra_stat: Dictionary = { # 0 = COMMON, 1 = UNCOMMON, 2 = LEGENDARY, 3 = RARE
	0: 0.5,
	1: 0.75,
	2: 1.0,
	3: 1.0
}

var rarity: int = 0

func _init():
	randomize()
	set_rarity()

func _ready():
	player = get_parent().player
	player.enemy_hit.connect(_on_hit)
	
	# populate the upgrade arrays
	for a in ability_upgrades:
		match a.rarity:
			0:
				common_upgrades.append(a)
			1:
				uncommon_upgrades.append(a)
			2:
				legendary_upgrades.append(a)
			3:
				rare_upgrades.append(a)
	get_rarity()

func get_rarity():
	match rarity:
		0:
			add_stats(common_upgrades)
		1:
			add_stats(uncommon_upgrades)
		2:
			add_stats(legendary_upgrades)
		3:
			add_stats(rare_upgrades)

func add_stats(stats: Array[AbilityUpgradeResource]):
	var number_of_stats: int = 1
	if randf() < chance_for_extra_stat[rarity]:
		number_of_stats = 2
	
	for s in stats:
		upgrades.append(s)
	
	for i in range(number_of_stats):
		var stat_to_add: AbilityUpgradeResource = get_upgrade_stat()
		upgrades_to_add.append(stat_to_add)

func get_upgrade_stat():
	var upgrade = upgrades.pick_random()
	if upgrades_to_add.has(upgrade):
		return get_upgrade_stat()
	return upgrade

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

func _on_hit(enemy: Enemy, source: Variant, damage: float):
	pass

func _on_shoot(player: Player, arm: Arm, damage: float):
	pass
