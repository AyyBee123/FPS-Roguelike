class_name ItemPickup extends Node3D

@onready var passive = %Passive
@onready var sprite_3d = %Sprite3D
@onready var default_pos = sprite_3d.get_position()

const AMPLITUDE: float = 0.1
const FREQUENCY: float = 2.0

var item: Item
var time: float = 0.0

var rarity_weights = ItemPool.rarity_weights

func _ready():
	if item == null:
		item = ItemPool.roll()
	sprite_3d.texture = item.texture
	passive.add_child(item)

func _physics_process(delta):
	time += delta * FREQUENCY
	sprite_3d.set_position(default_pos + Vector3(0, sin(time) * AMPLITUDE, 0))

func pick_up(player):
	item.on_pick_up(player)
	passive.remove_child(item)
	player.passives.add_child(item)
	queue_free()
