extends ColorRect

@export var player: Player
@export var ITEM_CONTAINER = preload("uid://dh2er4iqpdaa2")

@onready var items_container = %"Items Container"

func _ready():
	player.item_picked.connect(update_items)

func update_items(_pickup):
	for i in items_container.get_children():
		items_container.remove_child(i)
		i.queue_free()
	
	for item in player.get_node("%Passives").get_children():
		var cont = ITEM_CONTAINER.instantiate()
		cont.texture = item.icon
		cont.number_of_stacks = item.stacks
		items_container.add_child(cont)
