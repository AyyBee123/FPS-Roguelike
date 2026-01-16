extends Control

@export var player: Player
@export var marker: PackedScene
@export var item_ui: PackedScene

@onready var damage_indicators: Control = %"Damage Indicators"

var item_queue: Array[ItemInfoResource] = []
var current_item: ItemInfoResource
var item_display: ColorRect

func _ready():
	player.hit_taken.connect(_on_taking_damage)
	player.item_picked.connect(_on_item_pickup)

func _physics_process(delta):
	if item_queue.size() > 0 and not item_display:
		current_item = item_queue.pop_front()
		item_display = item_ui.instantiate()
		item_display.item = current_item
		item_display.position = Vector2(640, 824)
		add_child(item_display)

func _on_taking_damage(pos: Vector2):
	var mk = marker.instantiate()
	mk.rotation = atan2(pos.y, pos.x)
	damage_indicators.add_child(mk)

func _on_item_pickup(item: Item):
	var item_resource = ItemInfoResource.new()
	item_resource.item_name = item.item_name
	item_resource.icon = item.icon
	item_resource.description = item.description
	item_queue.append(item_resource)
	print(item_queue)
