extends Item

var number_of_stacks: int = 1
var number_of_stacks_increase: int = 1
var base_number_of_stacks: int = number_of_stacks

func on_item_picked(item: Item):
	if item.is_in_group("Hologram") or not item: return
	for i in range(number_of_stacks):
		var dupe = item.duplicate() # create the extra item stack
		dupe.add_to_group("Hologram")
		dupe.on_pick_up(player)

func on_stack():
	number_of_stacks += number_of_stacks_increase

func set_detailed_desription():
	detailed_description %= [
		base_number_of_stacks,
		number_of_stacks_increase,
	]
