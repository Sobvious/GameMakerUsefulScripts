/// @description 

if keyboard_check_pressed(vk_space) {
	global.wingra1.Window_setResolution(800, 680);
	global.wingra1.Graphics_setViewport(0, 0, 320, 240);
	global.wingra2.Graphics_setViewport(320, 200, 480, 480);
}