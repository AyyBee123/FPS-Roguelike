extends GridContainer

@export var player: Player

var pos: Vector2 = Vector2(8, 8)
var current_size: Vector2 = Vector2(1440, 72)
var current_scale: Vector2 = Vector2.ONE
var item_length: float = 64.0

func _ready():
	sort_children.connect(fix_ratio)

func fix_ratio():
	columns = max(int(current_size.x * current_scale.x * 2 / item_length), 1)
	scale.x = min(current_size.x / size.x, 1.0)
	scale.y = scale.x
