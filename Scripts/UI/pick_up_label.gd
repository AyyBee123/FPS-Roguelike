extends Label

@export var player: Player

func _ready():
	player.item_hovered.connect(on_item_hovered)

func on_item_hovered(item):
	var item_name: String
	if not item:
		text = ""
	elif item is Chest:
		if player.coin_count >= item.cost:
			text = "Open Chest"
		else:
			text = ""
	elif item is ArmoryBox:
		text = "Open Armory Box"
	elif item is ArmPickup:
		text = "Pick up %s" % item.arm_name
	elif item is ItemPickup:
		text = "Pick up %s" % item.item_name
		if player.banish_amount > 0:
			text += "\n" + "Q to Banish (%d Left)" % player.banish_amount
