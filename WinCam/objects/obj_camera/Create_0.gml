/// @description 

Create = function() {

	room_speed = 200;
	m_camera = new D3DCamera(0);
	m_camera.SetHand(0);
	m_camera.PerspectiveMode();
	m_camera.SetEyeVector([0.0, 0.0, 10.0]);
	
	m_model_axis = m_camera.GetWingra().CreateAxis();
	
}

Step = function(deltaTime) {
	// Get Input
	var _input_look = [
		keyboard_check(vk_right)-keyboard_check(vk_left),
		keyboard_check(vk_down)-keyboard_check(vk_up)
	];
	var _input_movement = [
		keyboard_check(ord("D"))-keyboard_check(ord("A")),
		keyboard_check(ord("W"))-keyboard_check(ord("S"))
	];
	var _input_roll = keyboard_check(ord("E"))-keyboard_check(ord("Q"));
	var _input_fly = keyboard_check(ord("R"))-keyboard_check(ord("F"));
	
	_input_look = m_camera.GetWingra().MathD3DXVec2Normalize(_input_look);
	_input_movement = m_camera.GetWingra().MathD3DXVec2Normalize(_input_movement);
	
	// Look
	var _look_speed = pi/4.0;
	m_camera.Yaw(_look_speed*deltaTime*_input_look[0]);
	m_camera.Pitch(_look_speed*deltaTime*_input_look[1]);
	
	// Movement
	var _move_speed = 15.0;
	m_camera.Walk(_move_speed*deltaTime*_input_movement[1]);
	m_camera.Strafe(_move_speed*deltaTime*_input_movement[0]);
	
	// Roll
	var _roll_speed = pi/4.0;
	m_camera.Roll(_roll_speed*deltaTime*_input_roll);
	
	// Fly
	var _fly_speed = 5.0;
	m_camera.Fly(_fly_speed*deltaTime*_input_fly);
	
	// Camera Update
	m_camera.Update();
	
}

Draw = function() {
	vertex_submit(m_model_axis, pr_linelist, -1);
	draw_self();
}

DrawGUI = function() {
	m_camera.DrawDebug(0, 0);
}

Destroy = function() {
	
	m_camera.Release();
	delete m_camera;
	
	buffer_resize(m_model_axis, 0);
}

Create();