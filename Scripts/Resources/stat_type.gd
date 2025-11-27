class_name StatType extends Resource

@export_enum("Common", "Uncommon", "Legendary", "Rare") var rarity: int # rarity the stat shows up
@export_enum("Damage", "Fire_Rate", "Range", "Speed", "Move_Speed", "Splash_Radius", "Projectile_Count", \
		"Max_Health", "Extra_Jumps", "XP_Gained", "Luck", "Pickup_Radius") var stat: String
@export var amount: float
@export_enum("+", "x", "flat") var type: String
