/// @description 
cam_z += 3.0 * delta_time/1000000.0;

var _mat_view = Win.MathD3DXMatrixLookatRH([0.0, 0.0, cam_z], [1.0, 0.0, cam_z], [0.0, 0.0, 1.0]);
Win.Graphics_setMatrix(matrix_view, _mat_view);
Win2.Graphics_setMatrix(matrix_view, _mat_view);