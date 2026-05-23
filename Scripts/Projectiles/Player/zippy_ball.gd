extends "res://Scripts/Projectiles/Player/projectile.gd"

@export var BLAST: PackedScene

@onready var ball = %Ball

const MAX_AMOUNT: int = 50

static var zippy_balls: Array[RigidBody3D]
var material: StandardMaterial3D
var color: Color
var bounces: int = 4

func _ready():
	super._ready()
	zippy_balls.append(self)
	ball.set_instance_shader_parameter("zippy_albedo", color)

func _physics_process(delta):
	super._physics_process(delta)
	if zippy_balls.size() > MAX_AMOUNT:
		if self == zippy_balls[0]:
			queue_free()

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
	blast.color = color
	blast.position = position
	get_tree().current_scene.add_child(blast)

func _exit_tree():
	zippy_balls.erase(self)
