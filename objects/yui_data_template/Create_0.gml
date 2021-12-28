/// @description

// Inherit the parent event
event_inherited();

// the render instance for the resolved template element
template_item = undefined;

build = function() {
	// make/update the child item
	if template_item {
		instance_destroy(template_item);
		template_item = undefined;
	}
	if bound_values.resource_key != undefined {
		var template_element = yui_element.getTemplateElement(bound_values.resource_key);
		if template_element {
			template_item = yui_make_render_instance(template_element, data_context);
		}
		// else: log no matching data template?
	}
}

// forward the rest to the child item or vice versa

arrange = function(available_size) {
	draw_rect = available_size
	if template_item {
		template_item.arrange(available_size);
		return template_item.draw_size;
	}
	return draw_size;
}

move = function(xoffset, yoffset) {
	if template_item {
		template_item.move(xoffset, yoffset);
	}
}

onChildLayoutComplete = function(child) {
	if parent {
		parent.onChildLayoutComplete(self);
	}
}