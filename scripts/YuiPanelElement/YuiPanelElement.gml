/// @description renders a YUI Panel
function YuiPanelElement(_props, _resources, _slot_values) : YuiBaseElement(_props, _resources, _slot_values) constructor {
	static default_props = {
		type: "panel",
				
		// layout
		layout: "vertical",
		padding: 0,
		spacing: undefined,
		alignment: "default",
		// alignment is a struct with two properties:
		// .vertical:"top"|"bottom"|"stretch" - "center" not yet supported
		// .horizontal:"left"|"right"|"stretch" - "center" not yet supported
		
		// visuals
		background: undefined,
		bg_sprite: undefined,
		bg_color: undefined,
		border_color: undefined,
		border_thickness: 1,	
		theme: "default",
		
		// option A: explicitly list the elements in the panel
		elements: undefined,
		
		// option B: bind the element list to data, and use a template to render each element
		path: undefined, // defines the source path for the element list
		template: undefined, // the template to use when rendering elements from the path
	};
	
	props = yui_init_props(_props);
	yui_resolve_theme();
	
	props.elements = yui_bind(props.elements, resources, slot_values);
	
	spacing = props.spacing == undefined ? theme.panel.spacing : props.spacing;
	props.padding = yui_resolve_padding(props.padding);
	
	// live binding this is not (yet?) supported, but this enables $slot support
	props.layout = yui_bind(props.layout, resources, slot_values);
	
	var makeLayout = yui_resolve_layout(props.layout);
	// TODO: padding isn't used so remove it
	layout = new makeLayout(alignment, props.padding, spacing);
	
	// resolve slot/resource (not bindable currently)
	var background_expr = yui_bind(props.background, resources, slot_values);
	if background_expr != undefined {
		var bg_spr = yui_resolve_sprite_by_name(background_expr);
		if bg_spr {
			bg_sprite = bg_spr;
			bg_color = undefined;
		}
		else {
			bg_color = yui_resolve_color(background_expr);
			bg_sprite = undefined;
		}
	}
	else {
		bg_color = undefined;
		bg_sprite = undefined;
	}
	
	border_color = yui_resolve_color(yui_bind(props.border_color, resources, slot_values));
	
	if props.template != undefined {	
		item_element = yui_resolve_element(props.template, resources, slot_values, props.id + ":T");	
	}
	else {
		// generate item_elements if we have explicit elements
		item_elements = [];
		var i = 0; repeat array_length(props.elements) {
			var element = props.elements[i];
			var panel_item_id = props.id + "[" + string(i) + "]";
			item_elements[i] = yui_resolve_element(element, resources, slot_values, panel_item_id);
			i++;
		}
		element_count = i;
		
		// force layout to check if it's live
		layout.init(item_elements, undefined, props);
	}
	
	is_bound = base_is_bound
		|| yui_is_live_binding(props.elements);
		
	// ===== functions =====
		
	static getLayoutProps = function() {
		
		return {
			alignment: alignment,
			padding: props.padding,
			size: size,
			layout: layout,
		};
	}
	
	static getBoundValues = function(data, prev) {
		if data_source != undefined {
			data = yui_resolve_binding(data_source, data);
		}
		
		var is_visible = yui_resolve_binding(props.visible, data);
		if !is_visible return false;
		
		var opacity = yui_resolve_binding(props.opacity, data);
		
		if props.template != undefined {
			if props.elements == undefined throw "cannot use 'template' without 'elements'";
			
			// single template element for bound data_items
			var source_items = yui_resolve_binding(props.elements, data);
			var child_count = array_length(source_items);
			
			// we need to copy the array for diff detection to work
			var data_items = array_create(child_count);
			array_copy(data_items, 0, source_items, 0, child_count);
			
			var item_elements = array_create(child_count);
			var i = 0; repeat child_count {
				item_elements[i++] = item_element;
			}
		}
		else {
			// explicit elements bound to panel.data_context
			var child_count = element_count;
			var data_items = array_create(child_count);
			var i = 0; repeat child_count {
				data_items[i++] = data;
			}
			var item_elements = self.item_elements;
		}
		
		// diff
		if !layout.is_live
			&& prev
			&& opacity == prev.opacity
			&& child_count == prev.child_count
			&& array_equals(item_elements, prev.item_elements)
			&& array_equals(data_items, prev.data_items)
		{
			return true;
		}
		
		return {
			is_live: is_bound || layout.is_live,
			// border
			data_source: data,
			opacity: opacity,
			bg_sprite: bg_sprite,
			bg_color: bg_color,
			border_color: border_color,
			border_thickness: props.border_thickness,
			// panel
			child_count: child_count,
			item_elements: item_elements,
			data_items: data_items,
		};
	}
}