extends Button

var focused_once: bool = false
var initial_focus: bool = false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_focus_entered)

func _on_mouse_entered():
	grab_focus()

func _focus_entered():
	if initial_focus:
		return
