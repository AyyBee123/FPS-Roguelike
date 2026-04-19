extends Node

const AbilityPool = preload("uid://c3tr181aifqm8")
const ArmPool = preload("uid://652066s8oj06")
const ItemPool = preload("uid://caq32sajxn8pu")

var commands: Dictionary = {}
var player: Player
var level: Level
var ui: Control

var item_pool
var arm_pool
var ability_pool

func _ready():
	register_clear()
	register_giveitem()
	register_givearm()
	register_giveability()
	register_spawnarm()

func register_command(cmd: ConsoleCommand):
	commands[cmd.name] = cmd

func execute(text: String):
	parse_and_run(text)

func parse_and_run(text: String):
	var raw = text.strip_edges().split(" ")
	if raw.is_empty():
		return
	
	var cmd_name = raw[0].to_lower()
	raw.remove_at(0)
	
	if not commands.has(cmd_name):
		print_to_console("ERROR: Unknown command: " + cmd_name, Color.RED)
		return
	
	var cmd: ConsoleCommand = commands[cmd_name]
	
	var parsed_args = []
	
	for i in range(cmd.args_schema.size()):
		var schema = cmd.args_schema[i]
		
		if i >= raw.size():
			if schema.has("default"):
				parsed_args.append(schema["default"])
				continue
			else:
				print_to_console("ERROR: Missing argument: " + schema.name, Color.RED)
				return
		
		var value = raw[i]
		
		match schema.type:
			"int":
				if not value.is_valid_int():
					print_to_console("ERROR: Invalid number for " + schema.name, Color.RED)
					return
				parsed_args.append(int(value))
			"float":
				if not value.is_valid_float():
					print_to_console("ERROR: Invalid number for " + schema.name, Color.RED)
					return
				parsed_args.append(float(value))
			"string":
				parsed_args.append(value)
			_:
				parsed_args.append(value)
	
	cmd.run(parsed_args)

func register_clear():
	var cmd = ConsoleCommand.new()
	cmd.name = "clear"
	cmd.description = "Clear the command log"
	cmd.args_schema = []
	
	cmd.execute_callable = func(args):
		if ui:
			ui.log.clear()
	
	register_command(cmd)

func register_giveitem():
	var cmd = ConsoleCommand.new()
	cmd.name = "giveitem"
	cmd.description = "Give an item to the player"
	cmd.args_schema = [
		{name="item", type="string"},
		{name="amount", type="int", default=1}
	]
	
	cmd.execute_callable = func(args):
		var item_name: String = args[0]
		var amount: int = args[1]
		
		if amount <= 0:
			print_to_console("ERROR: Amount must be greater than 0", Color.RED)
			return
		
		var pools = [
			item_pool.common_pool,
			item_pool.uncommon_pool,
			item_pool.legendary_pool
		]
		
		var resulting_item: Item
		
		for pool in pools:
			resulting_item = find_from_pool(pool, item_name)
			if resulting_item:
				break
		
		if resulting_item == null:
			print_to_console("ERROR: No item with name %s exists" % item_name, Color.RED)
			return
		
		resulting_item.stacks = amount
		resulting_item.on_pick_up(player)
		
		print_to_console("Gave %d stack%s of %s" % [amount,"s" if amount > 1 else "", resulting_item.item_name])
	
	register_command(cmd)

func register_givearm():
	var cmd = ConsoleCommand.new()
	cmd.name = "givearm"
	cmd.description = "Give an arm to the player and equip it"
	cmd.args_schema = [
		{name="item", type="string"}
	]
	
	cmd.execute_callable = func(args):
		var arm_name: String = args[0]
		
		var pools = [
			arm_pool.common_pool,
			arm_pool.uncommon_pool,
			arm_pool.legendary_pool
		]
		
		var resulting_arm: Arm
		
		for pool in pools:
			resulting_arm = find_from_pool(pool, arm_name)
			if resulting_arm:
				break
		
		if resulting_arm == null:
			print_to_console("ERROR: No arm with name %s exists" % arm_name, Color.RED)
			return
		
		player.weapons_manager.swap_arm(resulting_arm.arm_name)
		
		print_to_console("Gave %s" % arm_name)
	
	register_command(cmd)

func register_giveability():
	var cmd = ConsoleCommand.new()
	cmd.name = "giveability"
	cmd.description = "Give an ability to the player"
	cmd.args_schema = [
		{name="item", type="string"}
	]
	
	cmd.execute_callable = func(args):
		var ability_name: String = args[0]
		
		var resulting_ability: Ability
		
		resulting_ability = find_from_pool(ability_pool.abilities, ability_name)
		
		if resulting_ability == null:
			print_to_console("ERROR: No ability with name %s exists" % ability_name, Color.RED)
			return
		
		player.get_upgrade(resulting_ability)
		
		print_to_console("Gave %s" % resulting_ability.ability_name)
	
	register_command(cmd)

func register_spawnarm():
	var cmd = ConsoleCommand.new()
	cmd.name = "spawnarm"
	cmd.description = "Spawn an arm pickup"
	cmd.args_schema = [
		{name="item", type="string"},
		{name="coord_x", type="float", default=0},
		{name="coord_z", type="float", default=0},
	]
	
	cmd.execute_callable = func(args):
		var arm_name: String = args[0]
		var x: float = args[1]
		var z: float = args[2]
		
		var pools = [
			arm_pool.common_pool,
			arm_pool.uncommon_pool,
			arm_pool.legendary_pool
		]
		
		var resulting_arm: Arm
		
		for pool in pools:
			resulting_arm = find_from_pool(pool, arm_name)
			if resulting_arm:
				break
		
		if resulting_arm == null:
			print_to_console("ERROR: No arm with name %s exists" % arm_name, Color.RED)
			return
		
		var pickup: ArmPickup = preload("uid://ba7erkb81ks3u").instantiate()
		pickup.arm = resulting_arm
		get_tree().current_scene.add_child(pickup)
		pickup.global_position = Vector3(x, 0, z)
		
		print_to_console("Spawned %s at (%d, %d)" % [resulting_arm.arm_name, x, z])
	
	register_command(cmd)

func find_from_pool(pool, _name):
	for item in pool:
		var n = item.resource_path.get_file().get_basename()
		if n.to_lower().begins_with(_name.to_lower()):
			return item.instantiate()
	return null

func print_to_console(text: String, color: Color = Color.WHITE):
	if ui == null: return
	ui.log.append_text("[color=#%s]%s[/color]\n" % [color.to_html(false), text])
