function WinGraphics(view = view_current) constructor {

	// Member Functions
	function Window_setResolution(width, height) {
		// Adapt Resolution
		window_set_size(width, height);
		// change application surface
		surface_resize(application_surface, width, height);
	}
	
	function Graphics_setViewport(x, y, width, height) {
		// Recreate view surface
		if surface_exists(view_surface_id[m_view]) {
			surface_free(view_surface_id[m_view]);
		}
		view_surface_id[m_view] = surface_create(width, height);
		
		// Set Viewport
		view_set_xport(m_view, x); view_set_yport(m_view, y);
		view_set_wport(m_view, width); view_set_hport(m_view, height);
		
		// Resize Camera
		camera_set_view_size(m_camera, width, height);
		camera_set_view_pos(m_camera, 0, 0);
		
		// Resize surface
		surface_resize(view_surface_id[m_view], width, height);
	}
	
	function Window_drawPortRectangle(colour = c_red) {
		var _colour_temp = draw_get_colour();
		draw_set_colour(colour);
		draw_rectangle(
		view_get_xport(m_view), view_get_yport(m_view),
		view_get_xport(m_view) + view_get_wport(m_view),
		view_get_yport(m_view) + view_get_hport(m_view), 1);
		draw_set_colour(_colour_temp);
	}
	
	function Graphics_initialize() {
		// Turn on z test and wirte enable
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
	}
	
	function Graphics_setMatrix(matrix_type, matrix) {
		// Set matrix for Transform
		switch (matrix_type) {
		case matrix_world:
			matrix_set(matrix_world, matrix);
			break;
		case matrix_view:
			camera_set_view_mat(m_camera, matrix);
			break;
		case matrix_projection:
			camera_set_proj_mat(m_camera, matrix);
		}
		
		camera_apply(m_camera);
	}
	
	function MathD3DXVec3Normalize(vec) {
		var _disp = sqrt(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);
		vec[0] = vec[0]/_disp;
		vec[1] = vec[1]/_disp;
		vec[2] = vec[2]/_disp;
		
		return vec;
	}
	
	function MathD3DXVec3CrossProduct(vec1, vec2) {
		var _result = array_create(3);
		_result[0] = vec1[1] * vec2[2] - vec1[2] * vec2[1];
		_result[1] = vec1[2] * vec2[0] - vec1[0] * vec2[2];
		_result[2] = vec1[0] * vec2[1] - vec1[1] * vec2[0];
		return _result;
	}
	
	function MathD3DXVec3DotProduct(vec1, vec2) {
		var _result ;
		_result = vec1[0]*vec2[0] + vec1[1]*vec2[1] + vec1[2]*vec2[2];
		return _result;
	}
	
	function MathD3DXMatrixLookatRH(vec_eye, vec_at, vec_up) {
		var _xaxis = array_create(3);
		var _yaxis = array_create(3);
		var _zaxis = array_create(3);
		var _result = array_create(16);
		
		_zaxis[0] = vec_eye[0]-vec_at[0];
		_zaxis[1] = vec_eye[1]-vec_at[1];
		_zaxis[2] = vec_eye[2]-vec_at[2];
		_zaxis = MathD3DXVec3Normalize(_zaxis);

		_xaxis = MathD3DXVec3Normalize(MathD3DXVec3CrossProduct(vec_up, _zaxis));
		_yaxis = MathD3DXVec3CrossProduct(_zaxis, _xaxis);
		
		_result = 
		[_xaxis[0], _yaxis[0], _zaxis[0], 0.0,
		 _xaxis[1], _yaxis[1], _zaxis[1], 0.0,
		 _xaxis[2], _yaxis[2], _zaxis[2], 0.0,
		 -MathD3DXVec3DotProduct(_xaxis, vec_eye), -MathD3DXVec3DotProduct(_yaxis, vec_eye), -MathD3DXVec3DotProduct(_zaxis, vec_eye), 1.0
		]
		
		return _result;
		
	}
	
	// Enable View
	view_enabled = true;
	view_visible[view] = true;
	
	// Member Variable
	m_view = view;
	m_camera = view_get_camera(view);

}
