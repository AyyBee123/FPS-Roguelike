@tool
extends EditorScript

## The folder containing scenes to process
@export_dir var scenes_folder: String = "res://Scenes/Passives/"

## The file to save JSON output to
@export_file("*.json") var output_file: String = "res://Data/passive_pool.json"

func _run() -> void:
	print("Building passive pool from:", scenes_folder)
	var results: Array = []
	_process_folder(scenes_folder, results)
	_save_to_json(results)
	print("Passive pool saved to:", output_file)

## Process scenes
func _process_folder(folder_path: String, results: Array) -> void:
	var dir: DirAccess = DirAccess.open(folder_path)
	if dir == null:
		push_error("Cannot open folder: %s" % folder_path)
		return
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		var full_path: String = folder_path.path_join(file_name)
		if file_name.ends_with(".tscn"):
			var data: Dictionary = _get_scene_data_safe(full_path)
			if data.size() > 0:
				results.append(data)
		file_name = dir.get_next()
	dir.list_dir_end()

## Loads scene safely and reads exported data (works even for non-tool scripts)
func _get_scene_data_safe(scene_path: String) -> Dictionary:
	var scene: PackedScene = load(scene_path)
	if scene == null:
		push_warning("Failed to load scene: %s" % scene_path)
		return {}
	# Before instantiating, check if the scene contains placeholders
	# (Non-tool scripts produce placeholder nodes in the editor)
	var scene_state: SceneState = scene.get_state()
	if scene_state == null:
		push_warning("Invalid scene state for: %s" % scene_path)
		return {}
	# Create a temp dictionary to store exported property values from the scene state
	var data: Dictionary = {
		"path": scene_path
	}
	# Scan all nodes in the scene for exported variables
	for i in range(scene_state.get_node_count()):
		var node_name: StringName = scene_state.get_node_name(i)
		var node_props: int = scene_state.get_node_property_count(i)
		for j in range(node_props):
			var prop_name: StringName = scene_state.get_node_property_name(i, j)
			var prop_value = scene_state.get_node_property_value(i, j)
			if prop_name in ["rarity"]:
				data[prop_name] = prop_value
	return data

## Save gathered data as JSON
func _save_to_json(data: Array) -> void:
	var dir_path: String = output_file.get_base_dir()
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(dir_path)):
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir_path))
	var file: FileAccess = FileAccess.open(output_file, FileAccess.WRITE)
	if file == null:
		push_error("Could not open file for writing: %s" % output_file)
		return
	file.store_string(JSON.stringify(data, "\t")) # pretty print
	file.close()
