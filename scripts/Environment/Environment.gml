/// @description execution environment
function Environment(enclosingEnv = undefined) constructor {
	self.values = {};
	self.enclosing = enclosingEnv;
	
	static define = function(name /* string */, value) {
		variable_struct_set(values, name, value);
	}
	
	static assign = function(name /* Token */, value) {
		if variable_struct_exists(values, name._lexeme) {
			variable_struct_set(values, name._lexeme, value);			
		}
		else if enclosing != undefined {
			enclosing.assign(name, value);
		}
		else {
			throw new RuntimeError(name, "Undefined variable '" + name._lexeme + "'.");
		}
	}
	
	static get = function(name /* Token */) {
		if variable_struct_exists(values, name._lexeme) {
			return variable_struct_get(values, name._lexeme);
		}
		else if enclosing != undefined {
			return enclosing.get(name);
		}
		else {
			return undefined; // until we support ?. !
			//throw new RuntimeError(name, "Undefined variable '" + name._lexeme + "'.");
		}
	}
}