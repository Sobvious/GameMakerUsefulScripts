#macro gGravity global.gravity_pixel
gGravity = 1000.0;

function Gravity() constructor {
	
	// public
	function ApplyGravity(deltaTime) {
		ApplySpecialVelocity("Gravity", [m_gravity[0]*deltaTime, m_gravity[1]*deltaTime]);
	}
	
	function GenerateNextVelocity() {
		m_velocity_previous = [
			m_velocity[0],
			m_velocity[1]
		];
		m_velocity = [0.0, 0.0];
		for (var i = ds_map_find_first(m_specialVelocityMap); i != undefined; i = ds_map_find_next(m_specialVelocityMap,i)) {
			var _velocity_now = m_specialVelocityMap[?i];
			var _velocityMax_now = m_specialVelocityMaxMap[?i];
			if _velocityMax_now[0] >= 0.0 {
				m_velocity[0] += median(-_velocityMax_now[0], +_velocityMax_now[0], _velocity_now[0]);
				_velocity_now[0] = m_velocity[0];
			}
			else {
				m_velocity[0] += _velocity_now[0];
			}
			if _velocityMax_now[1] >= 0.0 {
				m_velocity[1] += median(-_velocityMax_now[1], +_velocityMax_now[1], _velocity_now[1]);
				_velocity_now[1] = m_velocity[1];
			}
			else {
				m_velocity[1] += _velocity_now[1];
			}
		}
	}
		
	function Friction(deltaTime) {
		for (var i = ds_map_find_first(m_specialVelocityMap); i != undefined; i = ds_map_find_next(m_specialVelocityMap,i)) {
			var _velocity_now = m_specialVelocityMap[?i];
			var _gravity_power = point_distance(0.0, 0.0, m_gravity[0], m_gravity[1]);
			var _amount = [
				min(abs(m_friction_multiplier[0]*_gravity_power*deltaTime), abs(_velocity_now[0])),
				min(abs(m_friction_multiplier[1]*_gravity_power*deltaTime), abs(_velocity_now[1]))
			];
			var _sign = [
				-sign(_velocity_now[0]),
				-sign(_velocity_now[1])
			]
			_velocity_now[0] += _amount[0]*_sign[0];
			_velocity_now[1] += _amount[1]*_sign[1];
		}
	}
	
	function GenerateDisplacement(deltaTime) {
		m_displacement = [
			m_velocity[0] * deltaTime,
			m_velocity[1] * deltaTime
		];
	}

	function Place(deltaTime) {
		m_ground = noone;
		var _is_collis = (m_velocity[1] >= 0.0) 
		&& (collision_line(m_object.x, m_object.y, m_object.x, m_object.y + m_displacement[1], m_collisObj, 1, 0));
		if _is_collis {
			m_ground = noone;
			m_velocity[1] = 0.0;
			m_displacement[1] = 0.0;
			SetSpecialVelocity("Gravity", [0.0, 0.0]);
			while true {
				m_ground = collision_point(m_object.x, m_object.y, m_collisObj, 1, 0);
				if instance_exists(m_ground) {
					break; 
				}
				m_object.y++;
			}
			while true {
				if!collision_point(m_object.x, m_object.y, m_collisObj, 1, 0) { 
					m_object.y ++;
					break; 
				}
				m_object.y--;
			}
		}
		m_object.x += m_displacement[0];
		m_object.y += m_displacement[1];
	}
	
	function Process(deltaTime) {
		ApplyGravity(deltaTime);
		GenerateNextVelocity();
		Friction(deltaTime);
		GenerateDisplacement(deltaTime);
		Place(deltaTime);
	}
	
	function Destroy() {
		ds_map_destroy(m_specialVelocityMap);
		ds_map_destroy(m_specialVelocityMaxMap);
	}
	
	function IsOnGround() {
		return instance_exists(m_ground);
	}
	
	function AddSpecialVelocity(name, vector2) {
		ds_map_add(m_specialVelocityMap, name, vector2);
		ds_map_add(m_specialVelocityMaxMap, name, [-1.0, -1.0]);
	}
	
	function SetSpecialVelocity(name, vector2) {
		array_resize(ds_map_find_value(m_specialVelocityMap, name), 0);
		m_specialVelocityMap[?name] = [vector2[0], vector2[1]];
	}
	
	function SetSpecialVelocityMax(name, vector2) {
		array_resize(ds_map_find_value(m_specialVelocityMaxMap, name), 0);
		m_specialVelocityMaxMap[?name] = [vector2[0], vector2[1]];		
	}
	
	function ApplySpecialVelocity(name, vector2) {
		var _velocity = m_specialVelocityMap[?name];
		_velocity[0] += vector2[0];
		_velocity[1] += vector2[1];
	}
	
	function ApplyForce(name, vector2, time) {
		var _velocity = m_specialVelocityMap[?name];
		_velocity[0] += vector2[0]/m_mass/time;
		_velocity[1] += vector2[1]/m_mass/time;	
	}
	
	function EventCollision(force_vector2) {
		
	}
	
	// Getter/Setter
	function SetGround(boolean) { m_ground = boolean; }
	function GetGround() { return m_ground; } 
	function SetVelocity(vector2) { m_velocity = [vector2[0], vector2[1]]; }
	function GetVelocity() { return m_velocity; }
	function SetVelocityPrevious(vector2) { m_velocity_previous = [vector2[0], vector2[1]]; }
	function GetVelocityPrevious() { return m_velocity_previous; }
	function SetGravity(vector2) { m_gravity = [vector2[0], vector2[1]]; }
	function GetGraivty() { return m_gravity; }
	function SetDisplacement(vector2) { m_displacement = [vector2[0], vector2[1]]; }
	function GetDisplacement() { return m_displacement; }
	function SetCollisionObject(object) { m_collisObj = object; }
	function GetCollisionObject() { return m_collisObj; }
	function SetObject(object) { m_object = object; }
	function GetObject() { return m_object; }
	function SetFrictionMult(vector2) { m_friction_multiplier = [vector2[0], vector2[1]]; }
	function GetFrictionMult() { return m_friction_multiplier; }
	function SetSpecialVelocityMap(map) { m_specialVelocityMap = map; }
	function GetSpecialVelocityMap() { return m_specialVelocityMap; }
	function SetMass(mass) { m_mass = mass; }
	function GetMass() { return m_mass; }
	
	// private
	m_gravity = [0.0, gGravity];
	m_velocity = [0.0, 0.0];
	m_velocity_previous = [0.0, 0.0];
	m_displacement = [0.0, 0.0];
	m_ground = noone;
	m_collisObj = noone;
	m_object = noone;
	m_friction_multiplier = [0.8, 0.01242];
	m_specialVelocityMap = ds_map_create();
	m_specialVelocityMaxMap = ds_map_create();
	m_mass = 0.0;
	
	AddSpecialVelocity("Gravity", [0.0, 0.0]);
	
}


