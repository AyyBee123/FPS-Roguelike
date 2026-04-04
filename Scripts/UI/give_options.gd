extends VBoxContainer

@export var menu: Control

@onready var reroll = $Reroll
@onready var banish = $Banish
@onready var skip = $Skip

var player: Player

func _ready():
	player = menu.player
	visible = OS.has_feature("editor")
	for button: Button in get_children():
		button.disabled = not OS.has_feature("editor")

func _on_reroll_pressed():
	player.reroll_amount += 1

func _on_banish_pressed():
	player.banish_amount += 1

func _on_skip_pressed():
	player.skip_amount += 1
