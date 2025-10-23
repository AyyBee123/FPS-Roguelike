extends Node3D

@onready var passive = %Passive
@onready var mesh_instance = %MeshInstance
@onready var default_pos = mesh_instance.get_position()

var time: float = 0.0
var amplitude: float = 0.1
var frequency: float = 2.0
var item: Node

func _ready():
	randomize()
	item = ItemPool.item_pool.pick_random().instantiate()
	mesh_instance.mesh = item.mesh
	passive.add_child(item)

func _physics_process(delta):
	rotate_y(PI/2 * delta)
	
	time += delta * frequency
	mesh_instance.set_position(default_pos + Vector3(0, sin(time) * amplitude, 0))

func pick_up(player):
	item.on_pick_up(player)
	passive.remove_child(item)
	player.passives.add_child(item)
	queue_free()
