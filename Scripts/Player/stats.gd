extends Node

signal stat_changed(stat, old_value, new_value)

## "base" -> the base stat
## "+" -> the increase in the base stat (in decimal, e.g. 0.1 for a 10% increase)
## "x" -> the final multiplier of the base stat and the increase
@export var stats: Dictionary = {
	# character stats
	"Max_Health": { "base": 100.0, "+": 0, "x": 1, "flat": 0.0 },
	"Move_Speed": { "base": 8.0, "+": 0, "x": 1, "flat": 0.0 },
	"Jump_Height": { "base": 5.0, "+": 0, "x": 1, "flat": 0.0 },
	"Extra_Jumps": { "base": 0, "+": 0, "x": 1, "flat": 0 },
	"Fall_Speed": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Pickup_Radius": { "base": 2.0, "+": 0, "x": 1, "flat": 0.0 },
	"Slide_Speed": { "base": 10.0, "+": 0, "x": 1, "flat": 0.0 },
	"XP_Gained": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Luck": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Friction": { "base": 50.0, "+": 0, "x": 1, "flat": 0.0 },
	"Dashes": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Dash_Cooldown": { "base": 2.0, "+": 0, "x": 1, "flat": 0.0 },
	
	# arm stats
	"Damage": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Fire_Rate": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Range": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Speed": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Splash_Radius": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Projectile_Count": { "base": 1, "+": 0, "x": 1, "flat": 0 },
	"Crit_Chance": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Crit_Damage": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
}

## gets the final character stat value after calculations
func get_stat(stat_type: String) -> Variant:
	return ((stats[stat_type]["base"] * (1 + stats[stat_type]["+"])) + stats[stat_type]["flat"]) * stats[stat_type]["x"]

## adds a percent increase (e.g. +15% -> amount = 15)
func add_percent_stat(stat_type: String, amount: float) -> void:
	var old_value = get_stat(stat_type)
	stats[stat_type]["+"] += amount / 100.0
	stat_changed.emit(stat_type, old_value, get_stat(stat_type))

## adds a multiplier (e.g. x1.5 -> amount = 1.5)
func multiply_stat(stat_type: String, amount: Variant) -> void:
	var old_value = get_stat(stat_type)
	stats[stat_type]["x"] *= amount
	stat_changed.emit(stat_type, old_value, get_stat(stat_type))

## adds on to the multiplier (e.g. x1.5 -> amount = 1.5)
func add_multiplier_stat(stat_type: String, amount: Variant) -> void:
	var old_value = get_stat(stat_type)
	stats[stat_type]["x"] += amount
	stat_changed.emit(stat_type, old_value, get_stat(stat_type))

## adds a flat amount to the base (e.g. +2 -> amount = 2)
func add_flat_stat(stat_type: String, amount: Variant) -> void:
	var old_value = get_stat(stat_type)
	stats[stat_type]["flat"] += amount
	stat_changed.emit(stat_type, old_value, get_stat(stat_type))
