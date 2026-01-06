extends CenterContainer

var item_name: String

@onready var icon: TextureRect = %Icon
@onready var stacks: Label = %Stacks

var number_of_stacks: int
var texture: Texture

func _ready():
	icon.texture = texture
	if number_of_stacks > 1:
		stacks.text = "x%d" % number_of_stacks
	else:
		stacks.text = ""
