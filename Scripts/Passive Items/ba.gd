extends Item

@export var ORBITAL_STRIKE: PackedScene

var cooldown: float = 10.0 # cooldown in seconds
var t: float = INF

func _physics_process(delta):
	if t < cooldown:
		t += delta

func on_enemy_hit(_enemy: Enemy, _source: Variant, _damage: float):
	if t >= cooldown:
		t = 0.0
		var strike = ORBITAL_STRIKE.instantiate()
		strike.position = _enemy.position
		strike.damage = get_stat_value("Damage")
		strike.radius = get_stat_value("Splash_Radius")
		strike.player = player
		get_tree().current_scene.add_child(strike)

func on_stack():
	add_percent_stat("Damage", 50)
	add_percent_stat("Splash_Radius", 30)
