extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var BLAST: PackedScene

@onready var ball = %Ball

var material: StandardMaterial3D
var blast_color: Color
var bounces: int = 5

func _ready():
	super._ready()
	lifetime.start(10)
	ball.material_override = material
	blast_color = material.albedo_color
	bounces = int(range)

func _on_body_entered(body):
	bounces -= 1
	explode()
	lifetime.start()
	if body is Enemy:
		body.hit(damage, player, self)
	if bounces <= 0:
		queue_free()

func explode():
	var blast = BLAST.instantiate()
	blast.damage = damage
	blast.radius = radius
	blast.player = player
	blast.color = blast_color
	blast.position = position
	get_tree().current_scene.add_child(blast)
