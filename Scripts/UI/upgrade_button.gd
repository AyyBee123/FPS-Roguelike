extends "res://Scripts/UI/button.gd"

@export var menu: Control

@onready var passive_name: Label = %Name
@onready var description: Label = %Description
@onready var rarity: Label = %Rarity
@onready var upgrade_icon = %Icon

var passives: Array[Passive] = []
var ability: Ability
var player: Player
var player_abilities: Array[String]

func _ready():
	randomize()
	description.text = ""
	player = menu.player
	if randf() < 0.5:
		select_passive()
	else:
		get_abilities()
		select_ability()

func get_abilities():
	for a in player.abilities.get_children():
		player_abilities.append(a.ability_name)

func select_passive():
	var passive: Passive = PassivePool.get_stat()
	
	while menu.current_list.has(passive.stat_name):
		passive = PassivePool.get_stat()
	
	passives.append(passive)
	add_child(passive)
	menu.current_list.append(passive.stat_name)
	
	upgrade_icon.texture = passive.icon
	passive_name.text = "%s Module" % passive.stat_name
	
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

func select_ability():
	ability = AbilityPool.get_ability()
	
	# if the player has 3 (or more) abilities, only show upgrades for the existing ones
	if player.number_of_abilities >= 3:
		while not player_abilities.has(ability.ability_name) or menu.current_list.has(ability.ability_name):
			ability = AbilityPool.get_ability()
	else:
		while menu.current_list.has(ability.ability_name):
			ability = AbilityPool.get_ability()
	
	add_child(ability)
	menu.current_list.append(ability.ability_name)
	for a in player_abilities:
		if a == ability.ability_name: # set a flag if the player already has the ability
			ability.ability_exists = true
	
	upgrade_icon.texture = ability.icon
	passive_name.text = ability.ability_name
	
	if ability.ability_exists:
		match ability.rarity:
			0:
				rarity.text = "Common"
			1:
				rarity.text = "Uncommon"
			2:
				rarity.text = "Legendary"
			3:
				rarity.text = "Rare"
		
		for stat in ability.upgrades_to_add:
			var values: Array = [format_number(stat.amount), stat.stat.replace("_", " ")]
			match stat.type:
				"+":
					description.text += "+%s%% %s" % values
				"x":
					description.text += "%sx %s" % values
				"flat":
					description.text += "+%s %s" % values
			description.text += "\n"
	else:
		rarity.text = ""
		description.text = ability.description

func format_number(n: float) -> String:
	if is_equal_approx(n, int(n)):
		return str(int(n))
	return str(n)
