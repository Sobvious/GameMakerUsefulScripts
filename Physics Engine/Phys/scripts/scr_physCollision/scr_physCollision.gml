
function LineCollision2(phy_obj1, phy_obj2) {
	
	var x1 = phy_obj1.m_instance.x+phy_obj1.m_pointList[|0];
	var y1 = phy_obj1.m_instance.y+phy_obj1.m_pointList[|1];
	var x2 = phy_obj1.m_instance.x+phy_obj1.m_pointList[|2];
	var y2 = phy_obj1.m_instance.y+phy_obj1.m_pointList[|3];
	
	var x3 = phy_obj2.m_instance.x+phy_obj2.m_pointList[|0];
	var y3 = phy_obj2.m_instance.y+phy_obj2.m_pointList[|1];
	var x4 = phy_obj2.m_instance.x+phy_obj2.m_pointList[|2];
	var y4 = phy_obj2.m_instance.y+phy_obj2.m_pointList[|3];
	
	// Make Line Equation
	var line1 = Equation_line_fromTwoPoint(x1, y1, x2, y2);
	var line2 = Equation_line_fromTwoPoint(x3, y3, x4, y4);
		
	var a = line1[0];
	var b = line1[1];
	var c = line1[2];

	var d = line2[0];
	var e = line2[1];
	var f = line2[2];

	var collis_x = 0.0, collis_y = 0.0;
	
	// Whether the slop is same or not
	if (a*e != b*d) {
		
		collis_x = (b*f-c*e)/(a*e-b*d);
		
		// Is the line vertical?
		if (b != 0) {
			collis_y = (a*collis_x+c)/b;
		}
		else {
			// Then try other line
			collis_y = (d*collis_x+f)/e;
		}
		
	}
	else {
		return "parallel";
	}
	
	// Check the range
	var min_x, min_y, max_x, max_y;
	if (x1>x2) { min_x = x2; max_x = x1; } else { min_x = x1; max_x = x2; }
	if (y1>y2) { min_y = y2; max_y = y1; } else { min_y = y1; max_y = y2; }

	var is_out = (collis_x > max_x) || (collis_x < min_x) || (collis_y > max_y) || (collis_y < min_y);

	if (is_out) {
		return "out of range1";
	}
	
	if (x3>x4) { min_x = x4; max_x = x3; } else { min_x = x3; max_x = x4; }
	if (y3>y4) { min_y = y4; max_y = y3; } else { min_y = y3; max_y = y4; }

	var is_out = (collis_x > max_x) || (collis_x < min_x) || (collis_y > max_y) || (collis_y < min_y);

	if (is_out) {
		return "out of range2";
	}
	
	// Return the collision point
	return [collis_x, collis_y];
}

function PhysCollision() constructor {
	
	function LineCollision(x1, y1, x2, y2, x3, y3, x4, y4) {
		
		// Make Line Equation
		var line1 = Equation_line_fromTwoPoint(x1, y1, x2, y2);
		var line2 = Equation_line_fromTwoPoint(x3, y3, x4, y4);
		
		var a = line1[0];
		var b = line1[1];
		var c = line1[2];
	
		var d = line2[0];
		var e = line2[1];
		var f = line2[2];
	
		var collis_x = 0.0, collis_y = 0.0;
		
		// Whether the slop is same or not
		if (a*e != b*d) {
			
			collis_x = (b*f-c*e)/(a*e-b*d);
			
			// Is the line vertical?
			if (b != 0) {
				collis_y = (a*collis_x+c)/b;
			}
			else {
				// Then try other line
				collis_y = (d*collis_x+f)/e;
			}
			
		}
		else {
			return "parallel";
		}
		
		// Check the range
		var min_x, min_y, max_x, max_y;
		if (x1>x2) { min_x = x2; max_x = x1; } else { min_x = x1; max_x = x2; }
		if (y1>y2) { min_y = y2; max_y = y1; } else { min_y = y1; max_y = y2; }
	
		var is_out = (collis_x > max_x) || (collis_x < min_x) || (collis_y > max_y) || (collis_y < min_y);
	
		if (is_out) {
			return "out of range1";
		}
		
		if (x3>x4) { min_x = x4; max_x = x3; } else { min_x = x3; max_x = x4; }
		if (y3>y4) { min_y = y4; max_y = y3; } else { min_y = y3; max_y = y4; }
	
		var is_out = (collis_x > max_x) || (collis_x < min_x) || (collis_y > max_y) || (collis_y < min_y);
	
		if (is_out) {
			return "out of range2";
		}
		
		// Return the collision point
		return [collis_x, collis_y];
		
	}
	

	
}


function Equation_line_fromTwoPoint(x1, y1, x2, y2) {

	if (x2-x1 != 0.0) {
		var a = (y2-y1)/(x2-x1);
		var b = 1.0;
		var c = y1-a*x1;
	}
	else {
		var a = 1.0;
		var b = 0.0;
		var c = -x1;
	}

	return [a, b, c];

}
