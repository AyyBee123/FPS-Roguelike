extends "res://Scripts/UI/button.gd"

@export var character: PackedScene
@export var char_image: Texture2D
@export var char_name: String

@onready var character_name = %"Character Name"
@onready var image = %Image

func _ready():
	character_name.text = char_name
	image.texture = char_image

func _on_pressed():
	Globals.sfx.button_confirm.play()
	GameState.selected_character = character
