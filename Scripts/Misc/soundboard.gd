extends Node3D

var rarity: int

@onready var common_item: DeconflictedAudioPlayer = %CommonItem
@onready var uncommon_item: DeconflictedAudioPlayer= %UncommonItem
@onready var legendary_item: DeconflictedAudioPlayer = %"Legendary Item"

func _ready():
	common_item.finished.connect(_on_sound_finished)
	uncommon_item.finished.connect(_on_sound_finished)
	legendary_item.finished.connect(_on_sound_finished)
	
	match rarity:
		0:
			common_item.play()
		1:
			uncommon_item.play()
		2:
			legendary_item.play()

func _on_sound_finished():
	queue_free()
