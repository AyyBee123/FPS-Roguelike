class_name Ability extends Node

@export var icon: Texture
@export var ability_name: String
@export_multiline var description: String
@export var ability_upgrades: Array[AbilityUpgradeResource]
@export var stats: Dictionary = {
	# ability stats
	"Damage": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Fire_Rate": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Range": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Speed": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Splash_Radius": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Size": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Projectile_Count": { "base": 1, "+": 0, "x": 1, "flat": 0.0 },
	"Crit_Chance": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Crit_Damage": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Pierce": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
}

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
	player.weapon_fired.connect(_on_shoot)
	
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
			get_stats(common_upgrades)
		1:
			get_stats(uncommon_upgrades)
		2:
			get_stats(legendary_upgrades)
		3:
			get_stats(rare_upgrades)

func get_stats(_stats: Array[AbilityUpgradeResource]):
	var number_of_stats: int = 1
	if randf() < chance_for_extra_stat[rarity] and _stats.size() > 1:
		number_of_stats = 2
	
	for s in _stats:
		upgrades.append(s)
	
	for i in range(number_of_stats):
		var stat_to_add: AbilityUpgradeResource = get_upgrade_stat()
		upgrades_to_add.append(stat_to_add)

func add_stats(upgrade_list):
	for stat in upgrade_list:
		match stat.type:
			"+":
				add_percent_stat(stat.stat, stat.amount)
			"x":
				multiply_stat(stat.stat, stat.amount)
			"flat":
				add_flat_stat(stat.stat, stat.amount)

## adds a percent increase (e.g. +15% -> amount = 15)
func add_percent_stat(stat_type: String, amount: float) -> void:
	stats[stat_type]["+"] += amount / 100.0

## adds a multiplier (e.g. x1.5 -> amount = 1.5)
func multiply_stat(stat_type: String, amount: Variant) -> void:
	stats[stat_type]["x"] *= amount

## adds a flat amount to the base (e.g. +2 -> amount = 2)
func add_flat_stat(stat_type: String, amount: Variant) -> void:
	stats[stat_type]["flat"] += amount

## gets the final stat value, after calculating player and ability stats
func get_stat_value(stat_type: String, value: Variant = null):
	if value == null:
		value = stats[stat_type]["base"]
	var base_value = ((value / (1 + player.stats.stats[stat_type]["+"])) + player.stats.stats[stat_type]["flat"]) \
			/ player.stats.stats[stat_type]["x"]
	var final_value = ((base_value * (1 + stats[stat_type]["+"] + player.stats.stats[stat_type]["+"])) \
			+ stats[stat_type]["flat"] + player.stats.stats[stat_type]["flat"]) \
			* stats[stat_type]["x"] * player.stats.stats[stat_type]["x"]
	return final_value

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

func _on_shoot(projectile: Variant, damage: float):
	pass
