extends Item

var cooldown: float = 10.0 # cooldown in seconds
var t: float = INF

func _physics_process(delta):
	if t < cooldown:
		t += delta

func on_enemy_hit(_enemy: Enemy, _source: Variant, _damage: float):
	if t >= cooldown:
		t = 0.0
		print("Boom!")

func on_stack():
	add_percent_stat("Damage", 50)
