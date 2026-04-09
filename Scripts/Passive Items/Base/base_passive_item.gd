class_name Item extends Node

signal send_buff(buff)

@export var item_name: String
@export_enum("COMMON", "UNCOMMON", "LEGENDARY", "UNSET:-1") var rarity: int = -1
@export var icon: Texture
@export var unlocked_by_default: bool = true
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
}

@export var stacks: int = 1
var player: Player
var existing_item: Item
var signals_connected: bool = false

func _ready():
	set_detailed_desription()
	if get_parent().get_parent() is Player:
		player = get_parent().get_parent()
		setup_signals(player)
		on_pick_up(player)
		for i in range(stacks - 1):
			on_stack()

func on_pick_up(_player: Player):
	player = _player
	
	# stack the item if it already exists
	if player.get_node_or_null("%Passives/" + name) and player.get_node_or_null("%Passives/" + name) != self:
		existing_item = player.get_node("%Passives/" + name)
		existing_item.stacks += 1
		existing_item.on_stack()
		player.item_picked.emit(self)
		queue_free()
		return
	
	if get_parent() and get_parent() != player.get_node("%Passives"):
		get_parent().remove_child(self)
	if get_parent() != player.get_node("%Passives"):
		player.passives.add_child(self)
	on_first_stack()
	
	player.item_picked.emit(self)
	setup_signals(player)

func on_first_stack():
	pass

func on_stack():
	pass

func on_remove():
	pass

func on_stack_remove():
	pass

func setup_signals(_player: Player):
	if signals_connected: return
	signals_connected = true
	
	_player.enemy_killed.connect(on_enemy_killed)
	_player.enemy_hit.connect(on_enemy_hit)
	_player.weapon_fired.connect(on_weapon_fired)
	_player.weapon_shot.connect(on_weapon_shot)
	_player.weapon_spawned.connect(on_weapon_spawned)
	_player.item_picked.connect(on_item_picked)
	_player.leveled_up.connect(on_level_up)

func set_detailed_desription():
	pass

## gets the final stat value, after calculating player and item stats
func get_stat_value(stat_type: String, value: Variant = null):
	if value == null: # base stat of the item
		value = stats[stat_type]["base"]
	else: # scaling stat (e.g. the player's dealt damage)
		value = ((value / (1 + player.stats.stats[stat_type]["+"])) + player.stats.stats[stat_type]["flat"]) \
				/ player.stats.stats[stat_type]["x"]
	var final_value = ((value * (1 + stats[stat_type]["+"] + player.stats.stats[stat_type]["+"])) \
			+ stats[stat_type]["flat"] + player.stats.stats[stat_type]["flat"]) \
			* (stats[stat_type]["x"] + player.stats.stats[stat_type]["x"] - 1)
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

func on_weapon_shot(_arm: Arm, _source: Variant):
	pass

func on_weapon_spawned(_projectile: Variant, _damage: float):
	pass

func on_item_picked(_item: Item):
	pass

func on_level_up(_level: int, _source: Variant):
	pass
