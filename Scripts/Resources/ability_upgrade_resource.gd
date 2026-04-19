class_name AbilityUpgradeResource extends Resource

@export_enum("Common", "Uncommon", "Legendary", "Rare") var rarity: int # rarity the stat shows up
@export_enum("Damage", "Fire_Rate", "Range", "Speed", "Splash_Radius", "Projectile_Count", "Extra_Jumps") var stat: String
@export var amount: float
@export_enum("+", "x", "flat") var type: String
@export var upgrade_for_player: bool = false # checks whether an upgrade is for the player or ability
