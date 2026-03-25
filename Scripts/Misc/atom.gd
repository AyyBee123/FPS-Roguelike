@tool
extends Node3D

@onready var pivot = %Pivot
@onready var pivot_2 = %Pivot2
@onready var pivot_3 = %Pivot3
@onready var p_n = %"Protons & Neutrons"

var atom_speed: float = PI/12
var electron_speed: float = TAU

func _ready():
	pivot_2.rotation.y = -electron_speed/2
	pivot_3.rotation.y = electron_speed/2

func _physics_process(delta):
	pivot.rotation.y += electron_speed * delta
	pivot_2.rotation.y -= electron_speed * delta
	pivot_3.rotation.y += electron_speed * delta
	
	p_n.rotation.x += atom_speed * delta
	p_n.rotation.y += atom_speed * delta
	p_n.rotation.z += atom_speed * delta
