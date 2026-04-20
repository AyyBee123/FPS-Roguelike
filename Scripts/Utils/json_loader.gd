extends Node
class_name PoolLoader

var weights: Array = []

func load_pool(path: String, pool: Array[PackedScene], rarity: int = -1) -> void:
	if not FileAccess.file_exists(path):
		push_error("File not found at: " + path)
		return

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + path)
		return

	var text: String = file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if parsed == null:
		push_error("Failed to parse JSON: invalid format.")
		return

	if typeof(parsed) != TYPE_ARRAY:
		push_error("Expected JSON array at root, got: " + str(typeof(parsed)))
		return

	pool.clear()
	for data in parsed:
		if rarity != -1:
			if data.has("rarity") and int(data["rarity"]) == rarity:
				pool.append(load(data["path"]))
		else:
			pool.append(load(data["path"]))
