@tool
extends EditorScript

func _run():
	var scene := get_editor_interface().get_edited_scene_root()
	if scene == null:
		push_error("No scene open.")
		return
	
	var mesh_instances := scene.find_children("", "MeshInstance3D", true)
	
	for mesh_node: MeshInstance3D in mesh_instances:
		if mesh_node.mesh == null:
			continue
		
		for i in range(mesh_node.mesh.get_surface_count()):
			var material := mesh_node.mesh.surface_get_material(i)
			
			if material is StandardMaterial3D:
				mesh_node.mesh.surface_set_material(i, material)
				material.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
				material.specular_mode = BaseMaterial3D.SPECULAR_TOON
	
	print("Material override complete.")
