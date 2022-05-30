
function PhysCollider(instanceID = noone) constructor {
	function ShapeLine(x1, y1, x2, y2) {
		ds_list_clear(m_pointList);
		ds_list_add(m_pointList, x1);
		ds_list_add(m_pointList, y1);
		ds_list_add(m_pointList, x2);
		ds_list_add(m_pointList, y2);
	}
	
	function Destroy() {
		ds_list_destroy(m_pointList);
	}
	
	function Draw() {
		draw_set_colour(c_red);
		draw_line(m_instance.x+m_pointList[|0], m_instance.y+m_pointList[|1],
		m_instance.x+m_pointList[|2], m_instance.y+m_pointList[|3]);
	}
	
	m_pointList = ds_list_create();
	m_instance = instanceID;
}
