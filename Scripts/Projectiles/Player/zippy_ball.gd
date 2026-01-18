extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var BLAST: PackedScene

@onready var ball = %Ball

var material: StandardMaterial3D
var blast_color: GradientTexture1D
var bounces: int = 5

func _ready():
	ball.material_override = material
	blast_color = GradientTexture1D.new()
	blast_color.gradient = Gradient.new()
	blast_color.gradient.set_color(0, material.albedo_color)
	blast_color.gradient.set_color(1, material.albedo_color)
	blast_color.resource_local_to_scene = true

func _on_body_entered(body):
	bounces -= 1.0
	explode()
	if body is Enemy:
		body.hit(damage, player, self)
	if bounces <= 0:
		queue_free()

func explode():
	var blast = BLAST.instantiate()
	blast.damage = damage
	blast.radius = radius
	blast.player = player
	blast.gradiant = blast_color
	blast.position = position
	get_tree().current_scene.add_child(blast)
