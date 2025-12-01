extends Node3D

@onready var muzzle_planes: GPUParticles3D = %MuzzlePlanes
@onready var muzzle_cone: GPUParticles3D = %MuzzleCone
@onready var flash: GPUParticles3D = %Flash

func _ready():
	randomize()
	rotate_z(randf_range(0, TAU))
	muzzle_planes.emitting = true
	muzzle_cone.emitting = true
	flash.emitting = true

func set_color(color: Color):
	muzzle_planes.process_material.color = color
	muzzle_cone.process_material.color = color
	flash.process_material.color = color

func _on_muzzle_planes_finished():
	queue_free()
