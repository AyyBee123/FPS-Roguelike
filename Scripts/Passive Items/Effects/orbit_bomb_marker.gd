extends Node3D

@export var BLAST: PackedScene
@export var BA: PackedScene

@onready var ray_cast: RayCast3D = %RayCast3D
@onready var decal: Decal = %Decal
@onready var marker: Node3D = %Marker
@onready var beam: MeshInstance3D = %Beam
@onready var sheep_falling = %"Sheep Falling"

var radius: float
var damage: float
var player: Player

var lifetime: float = 1.0
var tween: Tween

func _ready():
	randomize()
	var angle = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 50
	
	var ba = BA.instantiate()
	ba.marker = marker
	ba.position = position + Vector3(angle.x, 200, angle.y)
	ba.lifetime = lifetime
	add_child(ba)
	
	sheep_falling.play_deconflicted()
	
	var size = beam.scale
	var pos = beam.position
	var mat: StandardMaterial3D = beam.mesh.surface_get_material(0)
	var original_alpha = mat.albedo_color.a
	
	beam.scale.z = 0
	beam.position.y = -1
	mat.albedo_color.a = 0
	
	var l: float = lifetime * 0.9
	
	tween = get_tree().create_tween()
	tween.tween_property(mat, "albedo_color:a", original_alpha, l).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(beam, "scale:z", size.z, l).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(beam, "position:y", pos.y, l).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_interval(l * 0.1)
	tween.tween_callback(explode)

func _physics_process(delta):
	marker.global_position.y = ray_cast.get_collision_point().y # snap the chest to the ground (with offset)
	decal.rotation.y += delta * PI

func explode():
	var blast = BLAST.instantiate()
	blast.radius = radius
	blast.damage = damage
	blast.player = player
	blast.position = position
	get_tree().current_scene.add_child(blast)
	queue_free()
