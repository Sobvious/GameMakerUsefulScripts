/// @description 
Create = function() {
	room_speed = 60;
	m_gravity.SetCollisionObject(obj_cloud.object_index);
	m_gravity.AddSpecialVelocity("Movement", [0.0, 0.0]);
	m_gravity.SetSpecialVelocityMax("Movement", [m_stat_speedMax, 0.0]);
	m_gravity.SetObject(id);
}

Step = function(deltaTime) {
	m_gravity.Process(deltaTime);
	Move(deltaTime);
}

Draw = function() {
	draw_sprite_ext(sprite_index, 0, floor(x), floor(y), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	draw_text(12, 8, string(fps));
}

Destroy = function() {
	m_gravity.Destroy();
}

Move = function(deltaTime) {
	m_gravity.ApplySpecialVelocity("Movement",[	(isInput("Right") - isInput("Left")) * m_stat_speed*deltaTime,0.0]);
	m_gravity.ApplySpecialVelocity("Gravity",[0.0,-isInput("Up") * m_gravity.IsOnGround() * m_stat_jump]);
}

Create();
