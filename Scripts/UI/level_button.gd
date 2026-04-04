extends "res://Scripts/UI/button.gd"

@export var level: PackedScene
@export var image: Texture2D
@export var level_name: String

@onready var label = %"Level Name"
@onready var level_image = %"Level Image"

func _ready():
	label.text = level_name
	level_image.texture = image

func _on_pressed():
	Globals.sfx.button_confirm.play()
	GameState.selected_level = level
