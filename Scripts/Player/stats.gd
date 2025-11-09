extends Node

## "base" -> the base stat
## "+" -> the increase in the base stat (in decimal)
## "x" -> the final multiplier of the base stat and the increase
var stats: Dictionary = {
	# character stats
	"Max_Health": { "base": 100, "+": 0, "x": 1 },
	"Move_Speed": { "base": 8.0, "+": 0, "x": 1 },
	"Jump_Height": { "base": 5.0, "+": 0, "x": 1 },
	"Extra_Jumps": { "base": 0, "+": 0, "x": 1 },
	"Fall_Speed": { "base": 1.0, "+": 0, "x": 1 },
	"Pickup_Radius": { "base": 2.0, "+": 0, "x": 1 },
	"Slide_Speed": { "base": 10.0, "+": 0, "x": 1 },
	"XP_Gained": { "base": 1.0, "+": 0, "x": 1 },
	"Luck": { "base": 1.0, "+": 0, "x": 1 },
	
	# arm stats
	"Damage": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Fire_Rate": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Range": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Speed": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Splash_Radius": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Size": { "base": 1.0, "+": 0, "x": 1, "flat": 0.0 },
	"Projectile_Count": { "base": 1, "+": 0, "x": 1, "flat": 0.0 },
}

## gets the final character stat value after calculations
func get_stat(stat_type: String) -> Variant:
	return (stats[stat_type]["base"] * (1 + stats[stat_type]["+"])) * stats[stat_type]["x"]

func get_flat_stat(stat_type: String) -> Variant:
	return stats[stat_type]["flat"]

## adds a percent increase (e.g. +15% -> amount = 15)
func add_percent_stat(stat_type: String, amount: float) -> void:
	stats[stat_type]["+"] += amount / 100.0

## adds a multiplier (e.g. x1.5 -> amount = 1.5)
func multiply_stat(stat_type: String, amount: Variant) -> void:
	stats[stat_type]["x"] *= amount

## adds a flat amount to the base (e.g. +2 -> amount = 2)
func add_flat_amount(stat_type: String, amount: Variant) -> void:
	stats[stat_type]["base"] += amount
