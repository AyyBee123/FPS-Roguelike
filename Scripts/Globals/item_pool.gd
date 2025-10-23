extends Node

const SceneLoader = preload("res://Scripts/Utils/scene_loader.gd")

var item_pool: Array[PackedScene] = []

func _ready() -> void:
	item_pool = SceneLoader.load_scenes_from_folder("res://Scenes/Passive Items/")
	#print("Loaded %d item scenes" % item_pool.size())
