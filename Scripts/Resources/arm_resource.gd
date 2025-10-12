class_name ArmResource extends Resource

@export var arm_name: String # the name of the arm
@export var projectile: PackedScene # the projectile shot by the arm
@export var damage: float # damage dealt by the projectile
@export var fire_rate: float # in shots per second
@export var range: float # the distance (in pixels) before the projectile disappears
#@export_enum("Hit Scan", "Projectile", "Beam") var type
@export var shoot_animation: String = "Shoot"
@export var equip_animation: String = "Activate"
