instance uniform bool viewmodel_enabled = false;
instance uniform float z_clip_scale : hint_range(0.01, 1.0, 0.01) = 0.8;
instance uniform float fov_override : hint_range(1.0, 180.0, 0.1) = 100.0;

void apply_viewmodel(inout float zClipScale, inout mat4 projectionMatrix) {
	if (viewmodel_enabled) {
		zClipScale = z_clip_scale;
		
		if (!IN_SHADOW_PASS) {
			float flip_y = sign(projectionMatrix[1][1]);
			float aspect = projectionMatrix[1][1] / projectionMatrix[0][0];
			float f = flip_y / tan(fov_override * PI / 360.0);
			projectionMatrix[0][0] = f / aspect;
			projectionMatrix[1][1] = f;
		}
	}
}
