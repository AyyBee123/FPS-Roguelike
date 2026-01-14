extends Item

@export var ORBITAL_STRIKE: PackedScene
@export var BUFF: PackedScene

var cooldown: float = 10.0 # cooldown in seconds
var t: float = INF

var buff: Buff

func _physics_process(delta):
	if t < cooldown:
		t += delta
		if buff:
			buff.set_buff(t)

func on_enemy_hit(_enemy: Enemy, _source: Variant, _damage: float):
	if t >= cooldown:
		t = 0.0
		var strike = ORBITAL_STRIKE.instantiate()
		strike.position = _enemy.position
		strike.damage = get_stat_value("Damage")
		strike.radius = get_stat_value("Splash_Radius")
		strike.player = player
		get_tree().current_scene.add_child(strike)
		
		if not buff:
			buff = BUFF.instantiate()
			buff.source = self
			buff.cooldown = cooldown
			player.buffs.add_child(buff)

func on_stack():
	add_percent_stat("Damage", 50)
	add_percent_stat("Splash_Radius", 30)
