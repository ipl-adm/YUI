/// @description renders YUI text
function YuiTextElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {		
		type: "text",		
		theme: "default",
		padding: 0,
		
		text: undefined,
		text_format: undefined,
		
		text_style: "body",
		font: undefined, // overrides text_style.font
		color: undefined, // overrides text_style.color
		highlight_color: undefined,
				
		autotype: undefined, // simple option to enable typist.in()
		typist: undefined, // controls typewriter behavior
	};
	
	props = yui_init_props(_props);
	yui_resolve_theme();
	
	props.text = yui_bind(props.text, resources, slot_values);
	props.typist = yui_bind(props.typist, resources, slot_values);
	props.padding = yui_resolve_padding(props.padding);
	
	// look up the text style by name from the theme
	text_style = theme.text_styles[$ props.text_style];
	
	var font = props.font ?? text_style.font;
		
	color = props.color ?? text_style.color;
	color = yui_resolve_color(yui_bind(color, resources, slot_values));
	
	highlight_color = yui_resolve_color(yui_bind(props.highlight_color, resources, slot_values));
			
	if !is_string(font) font = font_get_name(font);
	else if !asset_get_index(font) {
		yui_warning ("could not find font with font name:", font, "- reverting to text_style.font");
		font = font_get_name(text_style.font);
	}
	self.font = font;
	
	is_text_live = yui_is_live_binding(props.text);
	
	// check if text is an array with bindings
	if is_array(props.text) {
		var i = 0; repeat array_length(props.text) {
			var text_item = props.text[i];
				
			// update binding expression to YuiBinding in place
			if yui_is_binding_expr(text_item) {
				is_text_live = true;
				var binding = yui_bind(text_item, resources, slot_values)
				props.text[i] = binding;
			}	
			i++;
		}
	}
	
	is_color_live = yui_is_live_binding(props.color);
	is_typist_live = yui_is_live_binding(props.typist);
	
	is_bound = base_is_bound
		|| is_text_live
		|| is_color_live
		|| is_typist_live;
		
	// ===== functions =====
	
	static getLayoutProps = function() {
		var halign = alignment.h == "center"
			? fa_center
			: fa_left
			
		var valign = alignment.v == "center"
			? fa_middle
			: fa_top
		
		return {
			padding: props.padding,
			size: size,
			halign: halign,
			valign: valign,
			highlight_color: highlight_color,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = is_data_source_bound ? data_source.resolve(data) : data_source;
		}
		
		var is_visible = is_visible_live ? props.visible.resolve(data) : props.visible;
		if !is_visible return false;
				
		var text = is_text_live && !is_array(props.text) ? props.text.resolve(data) : props.text;
		if text == "" || text == undefined {
			return false;
		}
		
		var color = is_color_live ? self.color.resolve(data) : self.color;
		var opacity = is_opacity_live ? props.opacity.resolve(data) : props.opacity;
		
		// handle text array by joining the values		
		if is_array(text) {
			var joined_text = "";
			var i = 0; repeat array_length(text) {
				var item_text = yui_resolve_binding(text[i++], data);
				joined_text += string(item_text);
			}
			text = joined_text;
		}
			
		if props.text_format != undefined
		{
			text = string_replace(props.text_format, "{0}", text);
		}
		
		var typist = is_typist_live ? props.typist.resolve(data) : props.typist;
		
		// diff
		if prev
			&& text == prev.text
			&& opacity == prev.opacity
			&& color == prev.color
			&& typist == prev.typist
		{
			return true;
		}
		
		return {
			is_live: is_bound,
			text: text,
			font: font,
			opacity: opacity,
			color: color,
			autotype: props.autotype,
			typist: typist,
		};
	}
}