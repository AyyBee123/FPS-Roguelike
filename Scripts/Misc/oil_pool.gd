extends Node3D

@export var tick_rate: float = 0.2

@onready var oil_pool: MeshInstance3D = %OilPool
@onready var area: Area3D = %Area3D
@onready var splat = %Splat

var tween: Tween

var damage: float
var speed: float
var range: float

var player: Player

var enemies: Array[Enemy]
var damage_timer: float = INF

func _ready():
	splat.play_deconflicted()
	scale = Vector3.ONE * player.stats.get_stat("Splash_Radius")
	oil_pool.scale = Vector3(0, 1.0 / scale.y, 0)
	tween = get_tree().create_tween()
	tween.tween_property(oil_pool, "scale:x", 1, 0.1)
	tween.parallel().tween_property(oil_pool, "scale:z", 1, 0.1)

func _physics_process(delta):
	damage_timer += delta
	if damage_timer >= tick_rate and enemies.size() > 0:
		damage_timer = 0.0
		for enemy in enemies:
			enemy.hit(damage, player, self)

func _on_lifetime_timeout():
	tween = get_tree().create_tween()
	tween.tween_property(oil_pool, "scale:x", 0, 0.25)
	tween.parallel().tween_property(oil_pool, "scale:z", 0, 0.25)
	tween.tween_callback(queue_free.call_deferred)

func _on_area_3d_body_entered(body):
	if not body is Enemy:
		return
	if not body.has_meta("oil_spill_overlapping"):
		body.set_meta("oil_spill_overlapping", [])
	body.get_meta("oil_spill_overlapping").append(self)
	enemies.append(body)

func _on_area_3d_body_exited(body):
	if not body is Enemy:
		return
	if body.has_meta("oil_spill_overlapping"):
		body.get_meta("oil_spill_overlapping", []).erase(self)
	enemies.erase(body)
