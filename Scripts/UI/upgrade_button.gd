extends "res://Scripts/UI/button.gd"

@onready var passive_name: Label = %Name
@onready var description: Label = %Description
@onready var rarity: Label = %Rarity

var passives: Array[Passive] = []

func _ready():
	var passive: Passive = PassivePool.get_stat()
	passives.append(passive)
	add_child(passive)
	passive_name.text = "%s Module" % passive.stat_name
	description.text = ""
	for stat in passive.stats_to_give:
		var values: Array = [format_number(stat.amount), stat.stat.replace("_", " ")]
		match stat.type:
			"+":
				description.text += "+%s%% %s" % values
			"x":
				description.text += "%sx %s" % values
			"flat":
				description.text += "+%s %s" % values
		description.text += "\n"
	match passive.rarity:
		0:
			rarity.text = "Common"
		1:
			rarity.text = "Uncommon"
		2:
			rarity.text = "Legendary"
		3:
			rarity.text = "Rare"
	
	if passive.rarity == 3:
		var second_passive: Passive = PassivePool.get_stat(passive)
		second_passive.rarity = 3 # hybrid/rare
		passives.append(second_passive)
		add_child(second_passive)
		passive_name.text = "%s/%s Module" % [passive.stat_name, second_passive.stat_name]
		for stat in second_passive.stats_to_give:
			var values: Array = [format_number(stat.amount), stat.stat.replace("_", " ")]
			match stat.type:
				"+":
					description.text += "+%s%% %s" % values
				"x":
					description.text += "%sx %s" % values
				"flat":
					description.text += "+%s %s" % values
			description.text += "\n"

func format_number(n: float) -> String:
	if is_equal_approx(n, int(n)):
		return str(int(n))
	return str(n)
