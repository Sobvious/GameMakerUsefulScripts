/// @description 
#macro Win global.window_graphic
Win = new WinGraphics(0);
Win.Window_setResolution(1280, 720);
Win.Graphics_setViewport(0, 0, 640, 480);
Win.Graphics_initialize();

var _mat_world = matrix_build_identity();
var _mat_view = Win.MathD3DXMatrixLookatRH([0.0, 0.0, 1.0], [1.0, 0.0, 1.0], [0.0, 0.0, -1.0]);
var _mat_proj = Win.MathD3DXMatrixPerspectiveFovRH(49.0, 640.0/480.0, 1.0, 32000.0);

Win.Graphics_setMatrix(matrix_world, _mat_world);
Win.Graphics_setMatrix(matrix_view, _mat_view);
Win.Graphics_setMatrix(matrix_projection, _mat_proj);

#macro Win2 global.window_graphic2
Win2 = new WinGraphics(1);
Win2.Graphics_setViewport(640, 240, 640, 480);
Win2.Graphics_initialize();

var _mat_view = Win2.MathD3DXMatrixLookatRH([0.0, 0.0, 1.0], [1.0, 0.0, 1.0], [0.0, 0.0, 1.0]);
var _mat_proj = Win2.MathD3DXMatrixPerspectiveFovRH(49.0, 640.0/480.0, 1.0, 32000.0);

Win2.Graphics_setMatrix(matrix_view, _mat_view);
Win2.Graphics_setMatrix(matrix_projection, _mat_proj);

cam_z = 1.0;