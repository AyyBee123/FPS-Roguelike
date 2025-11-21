class_name AbilityUpgradeResource extends Resource

@export_enum("Common", "Uncommon", "Legendary", "Rare") var rarity: int # rarity the stat shows up
@export_enum("Damage", "Fire_Rate", "Range", "Speed", "Splash_Radius", "Size", "Projectile_Count") var stat: String
@export var amount: float
@export_enum("+", "x", "flat") var type: String
