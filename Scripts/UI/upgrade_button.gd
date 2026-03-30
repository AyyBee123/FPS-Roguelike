extends "res://Scripts/UI/button.gd"

@export var menu: Control

@onready var passive_name: Label = %Name
@onready var description: Label = %Description
@onready var rarity: Label = %Rarity
@onready var upgrade_icon = %Icon
@onready var icon_rarity = %"Icon Rarity"
@onready var background_rarity = %"Background Rarity"

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
	mouse_entered.connect(func(): if not has_focus(): grab_focus())
	_on_focus_exited()

func get_abilities():
	for a in player.abilities.get_children():
		player_abilities.append(a.ability_name)

func select_passive():
	var passive: Passive = get_tree().current_scene.passive_pool.get_stat()
	
	while menu.current_list.has(passive.stat_name):
		passive = get_tree().current_scene.passive_pool.get_stat()
	
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
	
	var rarity_color: String
	match passive.rarity:
		0:
			rarity.text = "Common"
			rarity_color = "cccccc"
		1:
			rarity.text = "Uncommon"
			rarity_color = "42d042"
		2:
			rarity.text = "Legendary"
			rarity_color = "e68b19"
		3:
			rarity.text = "Rare"
			rarity_color = "4dbaff"
	icon_rarity.color = rarity_color
	rarity.modulate = rarity_color
	background_rarity.color = rarity_color
	
	if passive.rarity == 3:
		var second_passive: Passive = get_tree().current_scene.passive_pool.get_stat(passive)
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
	ability = get_tree().current_scene.ability_pool.get_ability()
	
	# if the player has 3 (or more) abilities, only show upgrades for the existing ones
	if player.number_of_abilities >= 3:
		while not player_abilities.has(ability.ability_name) or menu.current_list.has(ability.ability_name):
			ability = get_tree().current_scene.ability_pool.get_ability()
	else:
		while menu.current_list.has(ability.ability_name):
			ability = get_tree().current_scene.ability_pool.get_ability()
	
	add_child(ability)
	menu.current_list.append(ability.ability_name)
	for a in player_abilities:
		if a == ability.ability_name: # set a flag if the player already has the ability
			ability.ability_exists = true
			break
	
	upgrade_icon.texture = ability.icon
	passive_name.text = ability.ability_name
	
	if ability.ability_exists:
		var rarity_color: String
		match ability.rarity:
			0:
				rarity.text = "Common"
				rarity_color = "cccccc"
			1:
				rarity.text = "Uncommon"
				rarity_color = "42d042"
			2:
				rarity.text = "Legendary"
				rarity_color = "e68b19"
			3:
				rarity.text = "Rare"
				rarity_color = "4dbaff"
		
		icon_rarity.color = rarity_color
		rarity.modulate = rarity_color
		background_rarity.color = rarity_color
		
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

func _on_focus_entered():
	background_rarity.modulate = Color.WHITE * 0.65

func _on_focus_exited():
	background_rarity.modulate = Color.WHITE * 0.75

func _on_button_down():
	background_rarity.modulate = Color.WHITE * 0.5
