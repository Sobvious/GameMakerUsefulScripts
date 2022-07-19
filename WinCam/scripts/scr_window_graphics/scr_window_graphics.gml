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
		// Draw viewport with red colour
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
	
	function Graphics_end() {
		gpu_set_ztestenable(false);
	}

	//////////////////////////////////////
	/*				SHAPEs				*/
	//////////////////////////////////////
	
	function CreateAxis() {
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_color();
		var _format = vertex_format_end();
		
		var _vbuffer = vertex_create_buffer();
		vertex_begin(_vbuffer, _format);
		
			// X axis
			vertex_position_3d(_vbuffer, 0.0, 0.0, 0.0);
			vertex_color(_vbuffer, c_red, 1.0);
			vertex_position_3d(_vbuffer, 1.0, 0.0, 0.0);
			vertex_color(_vbuffer, c_red, 1.0);
			
			// Y axis
			vertex_position_3d(_vbuffer, 0.0, 0.0, 0.0);
			vertex_color(_vbuffer, c_green, 1.0);
			vertex_position_3d(_vbuffer, 0.0, 1.0, 0.0);
			vertex_color(_vbuffer, c_green, 1.0);
			
			// Z axis
			vertex_position_3d(_vbuffer, 0.0, 0.0, 0.0);
			vertex_color(_vbuffer, c_blue, 1.0);
			vertex_position_3d(_vbuffer, 0.0, 0.0, 1.0);
			vertex_color(_vbuffer, c_blue, 1.0);
			vertex_end(_vbuffer);
		
		return _vbuffer;
	}
	
	
	//////////////////////////////////////
	/*				MATH				*/
	//////////////////////////////////////
	
	function MathD3DXVec3Normalize(vec) {
		var _disp = sqrt(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);
		if _disp == 0 return [0.0, 0.0, 0.0];
		vec[0] = vec[0]/_disp;
		vec[1] = vec[1]/_disp;
		vec[2] = vec[2]/_disp;
		
		return vec;
	}

	function MathD3DXVec2Normalize(vec) {
		var _disp = sqrt(vec[0]*vec[0] + vec[1]*vec[1]);
		if _disp == 0 return [0.0, 0.0];
		vec[0] = vec[0]/_disp;
		vec[1] = vec[1]/_disp;
		
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
	
	function MathD3DXVec3Substract(vec1, vec2) {
		var _result = array_create(3);
		_result[0] = vec1[0] - vec2[0];
		_result[1] = vec1[1] - vec2[1];
		_result[2] = vec1[2] - vec2[2];
		
		return _result;
	}
	
	function MathD3DXVec3Multiply(vec, number) {
		var _result = array_create(3);
		_result[0] = vec[0]*number;
		_result[1] = vec[1]*number;
		_result[2] = vec[2]*number;
		return _result;
	}
	
	function MathD3DXVec3Add(vec1, vec2) {
		var _result = array_create(3);
		_result[0] = vec1[0] + vec2[0];
		_result[1] = vec1[1] + vec2[1];
		_result[2] = vec1[2] + vec2[2];
		return _result;
	}
	
	function MathD3DXMatrixLookatRH(vec_eye, vec_at, vec_up) {
		var _xaxis = array_create(3);
		var _yaxis = array_create(3);
		var _zaxis = array_create(3);
		var _result = matrix_build_identity();
		
		_zaxis = MathD3DXVec3Normalize(MathD3DXVec3Substract(vec_eye, vec_at));
		_xaxis = MathD3DXVec3Normalize(MathD3DXVec3CrossProduct(vec_up, _zaxis));
		_yaxis = MathD3DXVec3CrossProduct(_xaxis, _zaxis);
		
		
		_result = 
		[_xaxis[0], _yaxis[0], _zaxis[0], 0.0,
		 _xaxis[1], _yaxis[1], _zaxis[1], 0.0,
		 _xaxis[2], _yaxis[2], _zaxis[2], 0.0,
		 -MathD3DXVec3DotProduct(_xaxis, vec_eye), -MathD3DXVec3DotProduct(_yaxis, vec_eye), -MathD3DXVec3DotProduct(_zaxis, vec_eye), 1.0
		];
		
		return _result;
	}
	
	function MathD3DXMatrixLookatLH(vec_eye, vec_at, vec_up) {
		var _xaxis = array_create(3);
		var _yaxis = array_create(3);
		var _zaxis = array_create(3);
		var _result = matrix_build_identity();
		
		_zaxis = MathD3DXVec3Normalize(MathD3DXVec3Substract(vec_at, vec_eye));
		_xaxis = MathD3DXVec3Normalize(MathD3DXVec3CrossProduct(vec_up, _zaxis));
		_yaxis = MathD3DXVec3CrossProduct(_xaxis, _zaxis);
		
		_result = 
		[_xaxis[0], _yaxis[0], _zaxis[0], 0.0,
		 _xaxis[1], _yaxis[1], _zaxis[1], 0.0,
		 _xaxis[2], _yaxis[2], _zaxis[2], 0.0,
		 -MathD3DXVec3DotProduct(_xaxis, vec_eye), -MathD3DXVec3DotProduct(_yaxis, vec_eye), -MathD3DXVec3DotProduct(_zaxis, vec_eye), 1.0
		];
		
		return _result;
	}
	
	function MathD3DXMatrixPerspectiveFovRH(fovy, aspect, zn, zf) {
		var _result, _yScale, _xScale;
		_yScale = 1/tan(fovy/2.0);
		_xScale = _yScale/aspect;
		
		_result = [
			_xScale,		0.0,	0.0,			0.0,
			0.0,		_yScale,	0.0,			0.0,
			0.0,			0.0,	zf/(zn-zf),		-1.0,
			0.0,			0.0,	zn*zf/(zn-zf),	0.0
		];
		
		return _result;
	}
	
	function MathD3DXMatrixPerspectiveFovLH(fovy, aspect, zn, zf) {
		var _result, _yScale, _xScale;
		_yScale = 1/tan(fovy/2.0);
		_xScale = _yScale/aspect;
		
		_result = [
			_xScale,		0.0,	0.0,			0.0,
			0.0,		_yScale,	0.0,			0.0,
			0.0,			0.0,	zf/(zf-zn),		1.0,
			0.0,			0.0,	-zn*zf/(zf-zn),	0.0
		];
		
		return _result;
	}
	
	function MathD3DXMatrixOrthoRH(w, h, zn, zf) {
		return [
			2.0/w, 0.0, 0.0, 0.0,
			0.0, 2.0/h, 0.0, 0.0,
			0.0, 0.0, 1.0/(zn-zf), 0.0,
			0.0, 0.0, zn/(zn-zf), 0.0
		];
	}
	
	function MathD3DXMatrixOrthoLH(w, h, zn, zf) {
		return [
			2.0/w, 0.0, 0.0, 0.0,
			0.0, 2.0/h, 0.0, 0.0,
			0.0, 0.0, 1.0/(zf-zn), 0.0,
			0.0, 0.0, zn/(zn-zf), 0.0
		];
	}
	
	function MathD3DXMatrixScaling(scale) {
		return [
		scale, 0.0, 0.0, 0.0,
		0.0, scale, 0.0, 0.0,
		0.0, 0.0, scale, 0.0,
		0.0, 0.0, 0.0, 1.0
		];
	}
	
	function MathD3DXMatrixRotationX(angle) {
		return [
		1.0, 0.0, 0.0, 0.0,
		0.0, cos(angle), -sin(angle), 0.0,
		0.0, sin(angle), cos(angle), 0.0,
		0.0, 0.0, 0.0, 1.0
		];
	}

	function MathD3DXMatrixRotationY(angle) {
		return [
		cos(angle), 0.0, sin(angle), 0.0,
		0.0, 1.0, 0.0, 0.0,
		-sin(angle), 0.0, cos(angle), 0.0,
		0.0, 0.0, 0.0, 1.0
		];
	}
	
	function MathD3DXMatrixRotationZ(angle) {
		return [
			cos(angle), -sin(angle), 0.0, 0.0,
			sin(angle), cos(angle), 0.0, 0.0,
			0.0, 0.0, 1.0, 0.0,
			0.0, 0.0, 0.0, 1.0
		];
	}
	
	function MathD3DXMatrixTranslation(x, y, z) {
		return [
			1.0, 0.0, 0.0, x,
			0.0, 1.0, 0.0, y,
			0.0, 0.0, 1.0, z,
			0.0, 0.0, 0.0, 1.0
		];
	}
	
	function MathD3DXMatrixRotationAxis(vec, angle) {
		var nv = MathD3DXVec3Normalize(vec);
		var sangle = sin(angle);
		var cangle = cos(angle);
		var cdiff = 1-cangle;
		
		return [
			cdiff*nv[0]*nv[0]+cangle,		cdiff*nv[1]*nv[0]+sangle*nv[2], cdiff*nv[2]*nv[0]-sangle*nv[1], 0.0,
			cdiff*nv[0]*nv[1]-sangle*nv[2], cdiff*nv[1]*nv[1]+cangle,		cdiff*nv[2]*nv[1]+sangle*nv[0], 0.0,
			cdiff*nv[0]*nv[2]+sangle*nv[1], cdiff*nv[1]*nv[2]-sangle*nv[0], cdiff*nv[2]*nv[2]+cangle,		0.0,
			0.0, 0.0, 0.0, 1.0
		];
	}
	
	function MathHFovToVFov(horizontalFov, width, height) {
		return 2*arctan(tan(horizontalFov/2.0)*height/width);
	}
	
	function MathVFovToHFov(verticalFov, width, height) {
		return 2*arctan(tan(verticalFov/2.0)*width/height);
	}
	
	function MathD3DXVec3TransformCoord(matrix, vector) {
		var _result_vector = [vector[0], vector[1], vector[2], 1];
		for(var i = 0; i < 4; i ++) {
			_result_vector[i] = 
			_result_vector[0]*matrix[i*4+0]+
			_result_vector[1]*matrix[i*4+1]+
			_result_vector[2]*matrix[i*4+2]+
			_result_vector[3]*matrix[i*4+3];
		}
		return [_result_vector[0], _result_vector[1], _result_vector[2]];
	}
	
	// Getter/Setter
	function GetView() {
		return m_view;
	}
	function SetView(view) {
		m_view = view;
	}
	function GetCamera() {
		return m_camera;
	}
	function SetCamera(camera) {
		m_camera = camera;
	}
	function GetMatrixView() {
		return camera_get_view_mat(GetCamera());
	}
	function GetMatrixProj() {
		return camera_get_proj_mat(GetCamera());
	}
	
	// Enable View
	view_enabled = true;
	view_visible[view] = true;
	
	// Member Variable
	m_view = view;
	m_camera = view_get_camera(view);

}

function D3DCamera(view = view_current) constructor {
	
	function Initialize() {
		m_wingra.Graphics_initialize();
	}
	
	function PerspectiveMode() {
		// Perspective Transform
		var _mat_perspective;
		if m_hand == 0 {
			_mat_perspective = m_wingra.MathD3DXMatrixPerspectiveFovLH(m_perspective_fov, m_perspective_width/m_perspective_height, m_znear, m_zfar);
			//_mat_perspective = matrix_build_projection_perspective_fov(m_perspective_fov, m_perspective_width/m_perspective_height, m_znear, m_zfar);
		}
		else {
			_mat_perspective = m_wingra.MathD3DXMatrixPerspectiveFovRH(m_perspective_fov, m_perspective_width/m_perspective_height, m_znear, m_zfar);
		}
		m_wingra.Graphics_setMatrix(matrix_projection, _mat_perspective);
	}
	
	function OrthographyMode() {
		// Orthography Transform
		var _mat_orthography;
		if m_hand == 0 {
			_mat_orthography = m_wingra.MathD3DXMatrixOrthoLH(camera_get_view_width(m_camera), camera_get_view_height(m_camera), m_znear, m_zfar);
		}
		else {
			_mat_orthography = m_wingra.MathD3DXMatrixOrthoRH(camera_get_view_width(m_camera), camera_get_view_height(m_camera), m_znear, m_zfar);
		}
		m_wingra.Graphics_setMatrix(matrix_projection, _mat_orthography);
				
	}
	
	function Update() {
		// Look At Transform
		var _vec_face = GetFacingDirection();
		var _vec_at = m_wingra.MathD3DXVec3Add(_vec_face, m_vector_eye);
		var _mat_lookat;
		if m_hand == 0 {
			_mat_lookat = m_wingra.MathD3DXMatrixLookatLH(m_vector_eye, _vec_at, m_vector_up);
			//_mat_lookat = matrix_build_lookat(m_vector_eye[0], m_vector_eye[1], m_vector_eye[2], _vec_at[0], _vec_at[1], _vec_at[2], m_vector_up[0], m_vector_up[1], m_vector_up[2]);
		}
		else {
			_mat_lookat = m_wingra.MathD3DXMatrixLookatRH(m_vector_eye, _vec_at, m_vector_up);
		}
		m_wingra.Graphics_setMatrix(matrix_view, _mat_lookat);
		
	}
	
	function Release() {
		delete m_wingra;
	}
	
	function GetFacingDirection() {
		return m_wingra.MathD3DXVec3CrossProduct(m_vector_right, m_vector_up);
	}
	
	function Walk(units) {
		var _vec_adder = GetFacingDirection();
		_vec_adder = m_wingra.MathD3DXVec3Normalize(_vec_adder);
		_vec_adder = m_wingra.MathD3DXVec3Multiply(_vec_adder, units);
		m_vector_eye = m_wingra.MathD3DXVec3Add(_vec_adder, m_vector_eye);
	}
	function Strafe(units) {
		var _vec_adder = m_vector_right;
		_vec_adder = m_wingra.MathD3DXVec3Normalize(_vec_adder);
		_vec_adder = m_wingra.MathD3DXVec3Multiply(_vec_adder, units);
		m_vector_eye = m_wingra.MathD3DXVec3Add(_vec_adder, m_vector_eye);
	}
	function Yaw(units) {
		var _mat_transform = m_wingra.MathD3DXMatrixRotationAxis(m_vector_up, units);
		m_vector_right = matrix_transform_vertex(_mat_transform, m_vector_right[0], m_vector_right[1], m_vector_right[2]);
		m_vector_up = matrix_transform_vertex(_mat_transform, m_vector_up[0], m_vector_up[1], m_vector_up[2]);
	}
	function Pitch(units) {
		var _mat_transform = m_wingra.MathD3DXMatrixRotationAxis(m_vector_right, units);
		m_vector_up = matrix_transform_vertex(_mat_transform, m_vector_up[0], m_vector_up[1], m_vector_up[2]);
	}
	function Fly(units) {
		var _mat_transform = m_wingra.MathD3DXMatrixTranslation(m_vector_up[0]*units, m_vector_up[1]*units, m_vector_up[2]*units);
		m_vector_eye = m_wingra.MathD3DXVec3TransformCoord(_mat_transform, m_vector_eye);
	}
	function Roll(units) {
		var _vec_face = GetFacingDirection();
		var _mat_transform = m_wingra.MathD3DXMatrixRotationAxis(_vec_face, units);
		m_vector_up = matrix_transform_vertex(_mat_transform, m_vector_up[0], m_vector_up[1], m_vector_up[2]);
		m_vector_right = matrix_transform_vertex(_mat_transform, m_vector_right[0], m_vector_right[1], m_vector_right[2]);
	}
	function DrawDebug(x, y) {
		var _height = string_height("A");
		var _i = 0;
		draw_text(x, y+_i++*_height, "m_wingra: "+string(m_wingra));
		draw_text(x, y+_i++*_height, "m_camera: "+string(m_camera));
		draw_text(x, y+_i++*_height, "m_vector_up: "+string(m_vector_up));
		draw_text(x, y+_i++*_height, "m_vector_right: "+string(m_vector_right));
		draw_text(x, y+_i++*_height, "m_vector_eye: "+string(m_vector_eye));
		draw_text(x, y+_i++*_height, "m_perspective_width: "+string(m_perspective_width));
		draw_text(x, y+_i++*_height, "m_perspective_height: "+string(m_perspective_height));
		draw_text(x, y+_i++*_height, "m_perspective_fov: "+string(m_perspective_fov));
		draw_text(x, y+_i++*_height, "m_znear: "+string(m_znear));
		draw_text(x, y+_i++*_height, "m_zfar: "+string(m_zfar));
		draw_text(x, y+_i++*_height, "m_hand: "+string(m_hand));
	}
	
	// Getter / Setter
	function SetWingra(wingra) {
		m_wingra = wingra;
	}
	function GetWingra() {
		return m_wingra;
	}
	function SetUpVector(vector) {
		m_vector_up = vector;
	}
	function GetUpVector() {
		return m_vector_up;
	}
	function SetRightVector(vector) {
		m_vector_right = vector;
	}
	function GetRightVector() {
		return m_vector_right;
	}
	function SetEyeVector(vector) {
		m_vector_eye = vector;
	}
	function GetEyeVector() {
		return m_vector_eye;
	}
	function SetHand(hand) {
		m_hand = hand;
	}
	function GetHand() {
		return m_hand;
	}

	// Members
	m_wingra = new WinGraphics(view);
	m_camera = view_get_camera(view);
	
	m_vector_up = [0.0, 0.0, 1.0];
	m_vector_right = [0.0, 1.0, 0.0];
	m_vector_eye = [0.0, 0.0, 0.0];
	
	m_perspective_width = camera_get_view_width(m_wingra.GetCamera());
	m_perspective_height = camera_get_view_height(m_wingra.GetCamera());
	m_perspective_fov = degtorad(60.0);
	m_znear = 0.1;
	m_zfar = 32000.0;
	
	m_hand = 0; // 0: LH    1: RH

}
























