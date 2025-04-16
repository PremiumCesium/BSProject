class_name RuleSpacing

const SYMBOLS = [
	r"\*\*=",
	r"\*\*",
	"<<=",
	">>=",
	"<<",
	">>",
	"==",
	"!=",
	">=",
	"<=",
	"&&",
	r"\|\|",
	r"\+=",
	"-=",
	r"\*=",
	"/=",
	"%=",
	"&=",
	r"\^=",
	r"\|=",
	"~=",
	":=",
	"->",
	r"&",
	r"\|",
	r"\^",
	"-",
	r"\+",
	"/",
	r"\*",
	">",
	"<",
	"-",
	"%",
	"=",
	":",
	",",
];


static func apply(code: String) -> String:

	var string_regex = RegEx.new()
	string_regex.compile(r"([\"'])(?:(?=(\\?))\2.)*?\1")
	var string_matches = string_regex.search_all(code)
	var string_map = { }

	for i in range(string_matches.size()):
		var match = string_matches[i]
		var original = match.get_string()
		var placeholder = "__STRING__%d__" % i
		string_map[placeholder] = original
		code = _replace(code, original, placeholder)

	var comment_regex = RegEx.new()
	comment_regex.compile("#.*")
	var comment_matches = comment_regex.search_all(code)
	var comment_map = { }

	for i in range(comment_matches.size()):
		var match = comment_matches[i]
		var original = match.get_string()
		var placeholder = "__COMMENT__%d__" % i
		comment_map[placeholder] = original
		code = _replace(code, original, placeholder)

	var ref_regex = RegEx.new()
	ref_regex.compile(r"\$[^.]*")
	var ref_matches = ref_regex.search_all(code)
	var ref_map = { }

	for i in range(ref_matches.size()):
		var match = ref_matches[i]
		var original = match.get_string()
		var placeholder = "__REF__%d__" % i
		ref_map[placeholder] = original
		code = _replace(code, original, placeholder)

	code = _format_operators_and_commas(code)

	for placeholder in ref_map:
		code = code.replace(placeholder, ref_map[placeholder])
	for placeholder in comment_map:
		code = code.replace(placeholder, comment_map[placeholder])

	for placeholder in string_map:
		code = code.replace(placeholder, string_map[placeholder])
	return code


static func _format_operators_and_commas(code: String) -> String:
	var indent_regex = RegEx.create_from_string(r"^\s{4}")
	var new_code = indent_regex.sub(code, "\t", true)
	while(code != new_code):
		code = new_code
		new_code = indent_regex.sub(code, "\t", true)

	var symbols_regex = "(" + ")|(".join(SYMBOLS) + ")"
	var operator_regex = RegEx.create_from_string(" *?(" + symbols_regex + ") *")
	code = operator_regex.sub(code, " $1 ", true)

	# : =  => :=
	var define_regex = RegEx.create_from_string(r": *=")
	code = define_regex.sub(code, ":=", true)

	# a ( => a(
	var trim_left_regex = RegEx.create_from_string(r"(?<=[\w\)\]]) *([\(:,])(?!=)")
	code = trim_left_regex.sub(code, "$1", true)

	var trim_inside_left_regex = RegEx.create_from_string(r"([\(]) *")
	code = trim_inside_left_regex.sub(code, "$1", true)

	var trim_inside_right_regex = RegEx.create_from_string(r" *([\)])")
	code = trim_inside_right_regex.sub(code, "$1", true)

	var trim_regex = RegEx.new()
	trim_regex.compile("[ \t]*\n")
	code = trim_regex.sub(code, "\n", true)
	code = RegEx.create_from_string(" +").sub(code, " ", true)
	return code


static func _replace(text: String, what: String, forwhat: String) -> String:
	var index := text.find(what)
	if index != - 1:
		text = text.substr(0, index) + forwhat + text.substr(index + what.length())
	return text
