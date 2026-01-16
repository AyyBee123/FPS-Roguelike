extends ColorRect

@onready var icon = %Icon
@onready var item_name = %Name
@onready var description = %Description

var item: ItemInfoResource
var tween: Tween

func _ready():
	if item:
		icon.texture = item.icon
		item_name.text = item.item_name
		description.text = item.description
	else:
		queue_free()
	
	scale.y = 0
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale:y", 1, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_timer_timeout():
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale:y", 0, 0.333).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0.25, 0.333).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
