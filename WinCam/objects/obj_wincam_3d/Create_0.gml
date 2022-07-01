/// @description 
#macro Win global.window_graphic
Win = new WinGraphics(0);
Win.Window_setResolution(1280, 720);
Win.Graphics_setViewport(0, 0, 1280, 720);
Win.Graphics_initialize();

var _mat_world = matrix_build_identity();
var _mat_view = Win.MathD3DXMatrixLookatRH([0.0, 0.0, -1.0], [1.0, 0.0, -1.0], [0.0, 0.0, 1.0]);
var _mat_proj = matrix_build_projection_perspective_fov(59.0, 1280.0/720.0, 1.0, 32000.0);

Win.Graphics_setMatrix(matrix_world, _mat_world);
Win.Graphics_setMatrix(matrix_view, _mat_view);
Win.Graphics_setMatrix(matrix_projection, _mat_proj);
