extends Ability

@export var CLOUD: PackedScene
@export var BUFF: PackedScene

var cooldown: float = 2.0
var t: float = INF
var buff: Buff

func _physics_process(delta):
	super._physics_process(delta)
	if t < cooldown:
		t += delta
		if buff:
			buff.set_buff(t)

func _on_hit(enemy: Enemy, source: Variant, damage: float):
	if t < cooldown: return
	if not enemy or source.is_in_group("Venom Cloud"): return
	var cloud = CLOUD.instantiate()
	cloud.visible = false
	cloud.position = enemy.position
	cloud.damage = get_stat_value("Damage", damage)
	cloud.size = get_stat_value("Range")
	cloud.player = player
	get_tree().current_scene.add_child(cloud)
	cloud.visible = true
	t = 0.0
	
	if t < cooldown and not buff:
		buff = BUFF.instantiate()
		buff.source = self
		buff.cooldown = cooldown
		player.buffs.add_child(buff)
