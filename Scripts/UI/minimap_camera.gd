extends Camera3D

@export var player: Player

var height: float

func _ready():
	height = position.y

func _process(delta):
	global_position = player.global_position + Vector3(0, height, 0)
	rotation.y = player.rotation.y
