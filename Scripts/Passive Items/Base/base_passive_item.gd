class_name Item extends Node

@export_enum("COMMON", "UNCOMMON", "LEGENDARY", "UNSET:-1") var rarity: int = -1
@export var texture: Texture
@export_multiline var description: String
@export_multiline var detailed_description: String
@export var stats: Dictionary = {
	# ability stats
	"Damage": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
	"Fire_Rate": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
	"Range": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
	"Speed": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
	"Splash_Radius": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
	"Projectile_Count": { "base": 1, "+": 0.0, "x": 1.0, "flat": 0 },
	"Crit_Chance": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
	"Crit_Damage": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
	"Pierce": { "base": 1.0, "+": 0.0, "x": 1.0, "flat": 0.0 },
}

var player: Player
var stacks: int = 1
var existing_item: Item

func _ready():
	if get_parent().get_parent() is Player:
		player = get_parent().get_parent()
		setup_signals(player)

func on_pick_up(_player: Player):
	player = _player
	
	if player.get_node_or_null("%Passives/" + name): # stack the item if it already exists
		existing_item = player.get_node("%Passives/" + name)
		existing_item.stacks += 1
		existing_item.on_stack()
		queue_free()
		return
	else:
		get_parent().remove_child(self)
		player.passives.add_child(self)
	
	setup_signals(player)

func on_stack():
	pass

func setup_signals(_player):
	_player.enemy_killed.connect(on_enemy_killed)
	_player.enemy_hit.connect(on_enemy_hit)
	_player.weapon_fired.connect(on_weapon_fired)
	_player.weapon_shot.connect(on_weapon_shot)
	_player.weapon_spawned.connect(on_weapon_spawned)
	_player.item_picked.connect(on_item_picked)

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

## adds a percent increase (e.g. +15% -> amount = 15)
func add_percent_stat(stat_type: String, amount: float) -> void:
	stats[stat_type]["+"] += amount / 100.0

## adds a multiplier (e.g. x1.5 -> amount = 1.5)
func multiply_stat(stat_type: String, amount: Variant) -> void:
	stats[stat_type]["x"] *= amount

## adds on to the multiplier (e.g. x1.5 -> amount = 1.5)
func add_multiplier_stat(stat_type: String, amount: Variant) -> void:
	stats[stat_type]["x"] += amount

## adds a flat amount to the base (e.g. +2 -> amount = 2)
func add_flat_stat(stat_type: String, amount: Variant) -> void:
	stats[stat_type]["flat"] += amount

func on_enemy_killed(_enemy: Enemy, _source: Variant, _damage: float):
	pass

func on_enemy_hit(_enemy: Enemy, _source: Variant, _damage: float):
	pass

func on_weapon_fired(_projectile: Variant, _damage: float):
	pass

func on_weapon_shot(_arm: Arm):
	pass

func on_weapon_spawned(_projectile: Variant, _damage: float):
	pass

func on_item_picked(_pickup):
	pass
