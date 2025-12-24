extends Node3D

@export var tick_node: PackedScene
@export var tick_rate: float = 0.2

@onready var oil_pool: MeshInstance3D = $OilPool
@onready var area: Area3D = $Area3D

var tween: Tween

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

func _on_lifetime_timeout():
	tween = get_tree().create_tween()
	tween.tween_property(oil_pool, "scale:x", 0, 0.25)
	tween.parallel().tween_property(oil_pool, "scale:z", 0, 0.25)
	tween.tween_callback(queue_free)

func _on_area_3d_body_entered(body):
	if body is Enemy:
		var tick = tick_node.instantiate()
		tick.player = player
		tick.source = self
		tick.damage = damage
		tick.tick_rate = tick_rate
		body.add_child(tick)

func _on_area_3d_body_exited(body):
	if body is Enemy:
		var tick = body.get_node_or_null("Tick Damage")
		if tick:
			body.remove_child(tick)
