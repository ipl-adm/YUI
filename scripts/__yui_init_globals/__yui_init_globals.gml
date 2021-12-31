// define all YUI globals
global.__yui_globals = {};

// converts placement string values from a yui_file to the enum equivalent
global.__yui_globals.placement_map = {
	top_left: YUI_PLACEMENT_MODE.TopLeft,
	top_center: YUI_PLACEMENT_MODE.TopCenter,
	top_right: YUI_PLACEMENT_MODE.TopRight,
	left_top: YUI_PLACEMENT_MODE.LeftTop,
	left_middle: YUI_PLACEMENT_MODE.LeftCenter,
	left_bottom: YUI_PLACEMENT_MODE.LeftBottom,
	bottom_left: YUI_PLACEMENT_MODE.BottomLeft,
	bottom_center: YUI_PLACEMENT_MODE.BottomCenter,
	bottom_right: YUI_PLACEMENT_MODE.BottomRight,
	right_top: YUI_PLACEMENT_MODE.RightTop,
	right_middle: YUI_PLACEMENT_MODE.RightCenter,
	right_bottom: YUI_PLACEMENT_MODE.RightBottom,	
};