class_name RuleBlankLines


static func apply(code: String) -> String:
	var trim1_regex = RegEx.create_from_string("\n{2,}")
	code = trim1_regex.sub(code, "\n\n", true)
	code = _blank_for_func_class(code)
	var trim2_regex = RegEx.create_from_string("\n{3,}")
	code = trim2_regex.sub(code, "\n\n\n", true)
	return code


static func _blank_for_func_class( code: String) -> String:
	var func_class_regex = RegEx.create_from_string(".*(func|class) .*")
	var comment_line_regex = RegEx.create_from_string(r"^\s*#")
	var lines := code.split('\n')
	var modified_lines:Array[String] = []
	for line:String in lines:
		if func_class_regex.search(line):
			if modified_lines.size() > 0:
				var i := modified_lines.size() - 1
				while(comment_line_regex.search( modified_lines[i])):
					i -= 1
				modified_lines.insert(i + 1,"")
				modified_lines.insert(i + 1,"")
		modified_lines.append(line)
	return "\n".join(modified_lines)
