extends ColorRect

@export var player: Player
@export var ITEM_CONTAINER = preload("uid://dh2er4iqpdaa2")

@onready var item_container = %"Item Container"

func _ready():
	player.item_picked.connect(update_items)

func update_items(pickup):
	await get_tree().physics_frame # buffer to allow stacking items time to queue
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	for i in item_container.get_children():
		item_container.remove_child(i)
		i.queue_free()
	
	for item in player.passives.get_children():
		var cont = ITEM_CONTAINER.instantiate()
		cont.texture = item.texture
		cont.number_of_stacks = item.stacks
		item_container.add_child(cont)
