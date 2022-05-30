/// @description defines a theme for a YUI render tree
/// This means things like fonts, colors, and BG images to use for panels, buttons
function YuiTheme(_theme_id, _props) constructor {
	static default_props = {
		text_styles: {
			title: { font: fnt_yui_title, color: c_white },
			subtitle: { font: fnt_yui_subtitle, color: c_white },
			body: { font: fnt_yui_body, color: c_white },
		},
		text_input: {
			background: "#06162A",
			border_color: "grey",
			border_focus_color: "white",
			border_thickness: 1,
			padding: 7,
		},
		panel: {
			background: undefined,
			padding: 30,
			spacing: 5,
		},
		button: {
			background: "yui_button_bg",
			padding: [10, 5],
		},
		popup: {
			background: yui_color_from_hex_string("#06162A"),
			border_color: yui_color_from_hex_string("#2183C0"),
			border_thickness: 1.5,
			padding: 5,
		},
	}
	
	theme_id = _theme_id;
	props = yui_init_props(_props);
}