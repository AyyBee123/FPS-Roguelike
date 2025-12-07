extends Node3D

@onready var oil_pool: MeshInstance3D = $OilPool
@onready var area: Area3D = $Area3D
@onready var tick_rate: Timer = $"Tick Rate"

var tween: Tween
var enemies: Array[Enemy]

var damage: float
var speed: float
var range: float

var player: Player

func _ready():
	scale = Vector3.ONE * player.stats.get_stat("Splash_Radius")
	oil_pool.scale = Vector3(0, 1, 0)
	tween = get_tree().create_tween()
	tween.tween_property(oil_pool, "scale:x", 1, 0.1)
	tween.parallel().tween_property(oil_pool, "scale:z", 1, 0.1)

func _physics_process(delta):
	if tick_rate.is_stopped():
		for enemy in enemies:
			if enemy is Enemy:
				enemy.hit(damage, player, self)
		tick_rate.start()

func _on_lifetime_timeout():
	tween = get_tree().create_tween()
	tween.tween_property(oil_pool, "scale:x", 0, 0.25)
	tween.parallel().tween_property(oil_pool, "scale:z", 0, 0.25)
	tween.tween_callback(queue_free)

func _on_area_3d_body_entered(body):
	if body is Enemy:
		enemies.append(body)

func _on_area_3d_body_exited(body):
	if enemies.has(body):
		enemies.remove_at(enemies.find(body))
