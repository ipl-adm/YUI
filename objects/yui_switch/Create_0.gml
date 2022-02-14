/// @description init

// Inherit the parent event
event_inherited();

case_item = undefined;

build = function() {
	// clear out the old item;
	if case_item {
		instance_destroy(case_item);
		case_item = undefined;
	}
	
	opacity = parent.opacity
	
	// make/update the child item
	if bound_values.switch_value != undefined {
		if typeof(bound_values.switch_value) == "bool" {
			var key = bound_values.switch_value == 1
				? "true"
				: "false";
		}
		else {
			var key = string(bound_values.switch_value);
		}
		
		var case_element = yui_element.getCaseElement(key);		
		if case_element {
			case_item = yui_make_render_instance(case_element, data_context);
		}
	}
}

// forward the rest to the child item or vice versa

arrange = function(available_size) {
	draw_rect = available_size
	if case_item {
		case_item.arrange(available_size);
		return case_item.draw_size;
	}
	return draw_size;
}

move = function(xoffset, yoffset) {
	if case_item {
		case_item.move(xoffset, yoffset);
	}
}

onChildLayoutComplete = function(child) {
	if parent {
		parent.onChildLayoutComplete(self);
	}
}