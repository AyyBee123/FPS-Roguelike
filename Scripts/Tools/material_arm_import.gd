@tool
extends EditorScript

const SHADER = preload("uid://cj4vnuskofgdy")

func _run():
	var scene = get_editor_interface().get_edited_scene_root()
	if scene == null:
		push_error("No scene open.")
		return
	
	if not scene is Arm:
		push_error("Scene is not an arm scene.")
		return
	
	var mesh_instances = scene.find_children("", "MeshInstance3D", true)
	
	for mesh_node: MeshInstance3D in mesh_instances:
		if mesh_node.mesh == null:
			continue
		
		var override: Material = mesh_node.material_override
		if override and override is StandardMaterial3D:
			override.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
			override.specular_mode = BaseMaterial3D.SPECULAR_TOON
		
		for i in range(mesh_node.mesh.get_surface_count()):
			var material = mesh_node.mesh.surface_get_material(i)
			if material is StandardMaterial3D:
				mesh_node.mesh.surface_set_material(i, convert_to_shader_material(material))
	
	print("Material override complete.")

func convert_to_shader_material(std: StandardMaterial3D) -> ShaderMaterial:
	var shader_mat: ShaderMaterial = ShaderMaterial.new()
	shader_mat.shader = SHADER
	
	# copy the properties into shader parameters
	shader_mat.set_shader_parameter("albedo", std.albedo_color)
	
	if std.albedo_texture:
		shader_mat.set_shader_parameter("texture_albedo", std.albedo_texture)
	
	if std.emission_enabled:
		shader_mat.set_shader_parameter("emission", std.emission)
		shader_mat.set_shader_parameter("emission_energy", std.emission_energy_multiplier)
	
	return shader_mat
