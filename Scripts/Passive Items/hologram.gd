extends Item

var number_of_stacks: int = 1

func on_item_picked(pickup):
	if pickup.is_in_group("Hologram"): return
	if pickup is ItemPickup:
		if pickup.item.is_in_group("Hologram"): return
		for i in range(number_of_stacks):
			var item = pickup.item.duplicate() # create the extra item stack
			item.on_pick_up(player)
			pickup.add_to_group("Hologram")
			player.item_picked.emit(pickup)

func on_stack():
	number_of_stacks += 1
