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
	
	function D3D_initialize() {
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
	}
	
	// Enable View
	view_enabled = true;
	view_visible[view] = true;
	
	// Member Variable
	m_view = view;
	m_camera = view_get_camera(view);

}

