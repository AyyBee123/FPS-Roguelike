extends Node

## Loads all .tscn (or .scn) scenes in a given folder and returns them as an Array[PackedScene].
static func load_scenes_from_folder(folder_path: String) -> Array[PackedScene]:
	var result: Array[PackedScene] = []
	var dir := DirAccess.open(folder_path)
	
	if dir == null:
		push_error("Cannot open folder: " + folder_path)
		return result
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".remap"):
			file_name = file_name.replace(".remap", "")
		if not dir.current_is_dir() and (file_name.ends_with(".tscn") or file_name.ends_with(".scn")):
			var full_path := folder_path.path_join(file_name)
			var scene := load(full_path)
			var instance = scene.instantiate()
			print(instance.rarity)
			instance.queue_free()
			if scene is PackedScene:
				result.append(scene)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	return result
