/// @description 
#macro gController global.controller
#macro isInput global.controller.GetState

function Control() constructor {
	
	// public
	function AddInput(key, action) { 
		ds_map_add(m_inputMap, key, action);
	}
	
	function GetState(key) {
		var _action = m_inputMap[?key];
		return _action();
	}
	
	function Destroy() {
		ds_map_destroy(m_inputMap);
	}
	
	// private
	m_inputMap = ds_map_create();
	
}

Initialize = function() {
	
	persistent = true;
	
	gController = new Control();
	gController.AddInput("Right", function() { return keyboard_check(ord("D")); });
	gController.AddInput("Left", function() { return keyboard_check(ord("A")); });
	gController.AddInput("Up", function() { return keyboard_check(ord("W")); });
	
}

Step = function(deltaTime) {
	
}

Destroy = function() {
	gController.Destroy();
}

Initialize();
