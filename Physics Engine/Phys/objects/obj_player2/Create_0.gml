/// @description 
Create = function() {
	room_speed = 60.0;
	PhysicsInit();
}

Destroy = function() {
	PhysicsDestroy();
}

Step = function(deltaTime) {
	PhysicsOnIdle(deltaTime);
	Move(deltaTime);
}

Draw = function() {
	draw_sprite_ext(sprite_index, 0.0, floor(x), floor(y), image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	draw_text(12.0, 8.0, string(fps));
	m_collider.Draw();
}

PhysicsInit = function() {
	m_physics.AddVelocity("Gravity", [0.0, 0.0]);
	m_physics.SetMass(50.0);
	m_physics.AddCollisionObject(obj_cloud.object_index);
	m_collider.ShapeLine(0.0, 0.0, 0.0, -200.0);
	m_physics.SetCollider(m_collider);
}

PhysicsDestroy = function() {
	m_physics.Destroy();
	delete m_physics;	
}

PhysicsOnIdle = function(deltaTime) {
	var _gravity = m_physics.GetMass() * 1000.0;
	m_physics.ApplyForce("Gravity", [0.0, _gravity], deltaTime);
	m_physics.Process(deltaTime);	
}

Move = function(deltaTime) {
	
}

Create();
