class_name ItemPickup extends Node3D

@onready var passive = %Passive
@onready var sprite_3d: Sprite3D = %Sprite3D
@onready var default_pos = sprite_3d.get_position()
@onready var default_scale = sprite_3d.get_scale()
@onready var collision_shape = %CollisionShape

const AMPLITUDE: float = 0.1
const FREQUENCY: float = 2.0

var item: Item
var visual_item: Item
var time: float = 0.0

var item_name: String

const ROLLING_INTERVAL: float = 0.05
const ROLLING_TIME: float = 1.0
var elapsed_time: float = 0.0
var t: float = 0.0
var tween: Tween

var can_pickup: bool = false:
	set(value):
		can_pickup = value
		collision_shape.disabled = not value

var rolling_done: bool = false

var rarity_weights = ItemPool.rarity_weights

func _ready():
	randomize()
	sprite_3d.scale = default_scale * 0.5
	collision_shape.disabled = true
	if not item:
		item = ItemPool.roll()
	item_name = item.name
	passive.add_child(item)

func _physics_process(delta):
	if rolling_done:
		time += delta * FREQUENCY
		sprite_3d.set_position(default_pos + Vector3(0, sin(time) * AMPLITUDE, 0))
		sprite_3d.set_scale(default_scale + Vector3.ONE * sin(time) / 8.0)
	
	if not can_pickup:
		rapid_roll(delta)

func pick_up(player):
	item.on_pick_up(player)
	passive.remove_child(item)
	player.passives.add_child(item)
	queue_free()

func display_item(_item):
	visual_item = _item
	sprite_3d.texture = _item.texture

func rapid_roll(delta):
	if can_pickup:
		return
	
	t += delta
	elapsed_time += delta
	sprite_3d.scale += Vector3.ONE * delta * 0.333
	sprite_3d.position.y += delta * 0.06
	
	if t >= ROLLING_INTERVAL:
		t = 0
		if not visual_item:
			visual_item = ItemPool.roll()
		var i: Item = visual_item
		while i.name == visual_item.name:
			i = ItemPool.roll()
		display_item(i)
	
	if elapsed_time >= ROLLING_TIME:
		display_item(item)
		play_tween()
		can_pickup = true

func play_tween():
	tween = get_tree().create_tween()
	tween.tween_property(sprite_3d, "scale", default_scale * 1.5, 0.05)
	tween.parallel().tween_property(sprite_3d, "position:y", 0.06 * ROLLING_TIME, 0.05)
	tween.tween_property(sprite_3d, "scale", default_scale, 0.1)
	tween.tween_callback(func(): rolling_done = true)

func _exit_tree():
	if tween.is_running():
		tween.kill()
