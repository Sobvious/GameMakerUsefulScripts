
function PhysObj(instanceID = noone) constructor {

	// public member functions
	function Destroy() {
		ds_map_destroy(m_velocity_map);
		ds_map_destroy(m_velocity_max_map);
		ds_map_destroy(m_collisObj_list);
		array_resize(m_velocity_total, 0);
		if (m_collider != noone) {
			m_collider.Destroy();
			delete m_collider;
		}
	}
	
	function AddVelocity(velocity_name, velocity_vector2) {
		ds_map_add(m_velocity_map, velocity_name, velocity_vector2);
		ds_map_add(m_velocity_max_map, velocity_name, [-1.0, -1.0]);
	}
	
	function SetVelocityLimit(velocity_name, limit_vector2) {
		var _velocity_limit = m_velocity_max_map[?velocity_name];
	}
	
	function ApplyForce(velocity_name, force_vector2, time) {
		var _velocity = m_velocity_map[?velocity_name];
		var _velocity_adder;
		if (m_mass != 0) {
			_velocity_adder = [
				force_vector2[0]*time/m_mass,
				force_vector2[1]*time/m_mass
			];
		}
		_velocity[0] += _velocity_adder[0];
		_velocity[1] += _velocity_adder[1];
	}
	
	function GenerateTotalVelocity() {
		m_velocity_total[0] = 0.0;
		m_velocity_total[1] = 0.0;
		for (var i = ds_map_find_first(m_velocity_map); i != undefined; i = ds_map_find_next(m_velocity_map, i)) {
			var _velocity = m_velocity_map[?i];
			LimitVelocity(i);
			m_velocity_total[0] += _velocity[0];
			m_velocity_total[1] += _velocity[1];
		}
		
	}
	
	function ApplyFriction(deltaTime) {
		for (var i = ds_map_find_first(m_velocity_map); i != undefined; i = ds_map_find_next(m_velocity_map, i)) {
			var _velocity = m_velocity_map[?i];
			var _velocity_length = sqrt(_velocity[0]*_velocity[0]+_velocity[1]*_velocity[1]);
			var _amount = [
				m_friction[0]*_velocity_length*deltaTime,
				m_friction[1]*_velocity_length*deltaTime
			];
			var _sign = [
				sign(_velocity[0]),
				sign(_velocity[1])
			];
			_velocity[0] += _amount[0]*_sign[0];
			_velocity[1] += _amount[1]*_sign[1];
		}
	}
	
	function GenerateDisplacement(deltaTime) {
		m_displacement[0] = m_velocity_total[0]*deltaTime;
		m_displacement[1] = m_velocity_total[1]*deltaTime;
	}
	
	function Place() {
		var _collider1 = m_collider;
		for (var i = 0; i < ds_list_size(m_collisObj_list); i++) {
			var _collisObj_now = m_collisObj_list[|i];
			with (_collisObj_now) {
				var _collider2 = self.m_collider;
				var _collision_result = LineCollision2(_collider1, _collider2);
				if (!is_string(_collision_result)) {
					with (other) {
						
					}
				}
				
			}
		}
		m_instance.x += m_displacement[0];
		m_instance.y += m_displacement[1];
	}
	
	function Process(deltaTime) {
		GenerateTotalVelocity();
		ApplyFriction(deltaTime);
		GenerateDisplacement(deltaTime);
		Place();
	}
	
	function AddCollisionObject(object_index) {
		ds_list_add(m_collisObj_list, object_index);
	}
	
	// private member functions
	function LimitVelocity(velocity_name) {
		var _velocity = m_velocity_map[?velocity_name];
		var _velocity_limit = m_velocity_max_map[?velocity_name];
		if (_velocity_limit[0] >= 0.0) {
			_velocity[0] = median(-_velocity_limit[0], +_velocity_limit[0], _velocity[0]);
		}
		if (_velocity_limit[1] >= 0.0) {
			_velocity[1] = median(-_velocity_limit[1], +_velocity_limit[1], _velocity[1]);
		}
	}
	
	// Getter/Setter
	function SetMass(mass) { m_mass = mass; }
	function GetMass() { return m_mass; }
	function SetVelocityMap(velocityMap) { m_velocity_map = velocityMap; }
	function GetVelocityMap() { return m_velocity_map; }
	function SetVelocityMaxMap(velocityMaxMap) { m_velocity_max_map = velocityMaxMap; }
	function GetVelocityMaxMap() { return m_velocity_max_map; }
	function SetCollisObjectList(collisObjList) { m_collisObj_list = collisObjList; }
	function GetCollisObjectList() { return m_collisObj_list; }
	function SetCollider(collider) { m_collider = collider; }
	function GetCollider() { return m_collider; }
	function SetInstance(instanceID) { m_instance = instanceID; }
	function GetInstance() { return m_instance; }

	// member variable
	m_mass = 0.0;
	m_velocity_map = ds_map_create();
	m_velocity_max_map = ds_map_create();
	m_friction = [0.8, 0.01242];
	m_collisObj_list = ds_list_create();
	m_instance = instanceID;
	m_collider = noone;
	
		// read only
	m_velocity_total = [0.0, 0.0];
	m_displacement = [0.0, 0.0];

}


