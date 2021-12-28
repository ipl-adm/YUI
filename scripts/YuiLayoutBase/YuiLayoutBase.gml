
function YuiLayoutBase() constructor {
	
	static init = function(_draw_rect, _size, panel) {
		size = _size;		
		padding = panel.padding;
		
		//if panel.trace {
		//	var f = "f";
		//}
		
		// apply a custom alignment if specified
		// TODO: move to YuiElementAlignment() in panel constructor
		if panel.alignment != "default" {
			if is_string(panel.alignment) {
				alignment = {
					horizontal: panel.alignment,
					vertical: panel.alignment,
				};
			}
			else {
				var horizontal = panel.alignment[$ "horizontal"];
				if horizontal != undefined {
					alignment.horizontal = horizontal;
				}
				var vertical = panel.alignment[$ "vertical"];
				if vertical != undefined {
					alignment.vertical = vertical;
				}
			}
		}
		
		draw_rect = {
			x: _draw_rect.x,
			y: _draw_rect.y,
			w: _draw_rect.w,
			h: _draw_rect.h,
		};
		
		// allow the provided numeric size to override the draw rect
		// TODO: account for overflow (how?)
		if is_numeric(size.w) draw_rect.w = size.w;
		if is_numeric(size.h) draw_rect.h = size.h;
		
		// apply min/max constraints
		if size.min_w != undefined {
			draw_rect.w = min(draw_rect.w, size.min_w);
		}
		if size.max_w != undefined {
			draw_rect.w = min(draw_rect.w, size.max_w);
		}
		if size.min_h != undefined {
			draw_rect.h = min(draw_rect.h, size.min_h);
		}
		if size.max_h != undefined {
			draw_rect.h = min(draw_rect.h, size.max_h);
		}
				
		// apply the padding to the actual draw rect
		// this is the one that will get updated for each element
		current_draw_rect = yui_apply_padding(draw_rect, padding);
		padded_rect = yui_copy_rect(current_draw_rect);
		
		// this is the total size used up by the panel layout, including padding
		// (important for panels within other panels)
		draw_size = {
			w: padding.w,
			h: padding.h,
		}
		
		// return the actual draw_rect
		return draw_rect;
	}
	
	static getItemDrawRect = function(item_index) {
		// make a copy so that the item renderer can't accidentally mess up our draw rect
		var item_draw_rect = {
			x: current_draw_rect.x,
			y: current_draw_rect.y,
			w: current_draw_rect.w,
			h: current_draw_rect.h,
		};
		
		//if item_draw_rect.h <= 0 {
		//	yui_log("broken");
		//}
		
		return item_draw_rect;
	}
}