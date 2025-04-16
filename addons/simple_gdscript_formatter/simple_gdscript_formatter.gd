@tool
extends EditorPlugin

var FORMAT_ACTION := "simple_gdscript_formatter/format_code"
var format_key: InputEventKey


func _enter_tree():
	add_tool_menu_item("Format GDScript (Ctrl+Alt+L)", _on_format_code)

	if InputMap.has_action(FORMAT_ACTION):
		InputMap.erase_action(FORMAT_ACTION)
	InputMap.add_action(FORMAT_ACTION)

	format_key = InputEventKey.new()
	format_key.keycode = KEY_L
	format_key.ctrl_pressed = true
	format_key.alt_pressed = true
	InputMap.action_add_event(FORMAT_ACTION, format_key)


func _exit_tree():
	remove_tool_menu_item("Format GDScript (Ctrl+Alt+L)")
	InputMap.erase_action(FORMAT_ACTION)


func _on_format_code():
	var current_editor := EditorInterface.get_script_editor().get_current_editor()
	if current_editor and current_editor.is_class("ScriptTextEditor"):
		var text_edit = current_editor.get_base_editor()
		var code = text_edit.text
		var formatter = Formatter.new()
		var formatted_code = formatter.format_code(code)
		if formatted_code && code != formatted_code:
			var scroll_horizontal = text_edit.scroll_horizontal
			var scroll_vertical = text_edit.scroll_vertical
			var caret_column = text_edit.get_caret_column(0)
			var caret_line = text_edit.get_caret_line(0)
			text_edit.text = formatted_code
			text_edit.set_caret_line(caret_line)
			text_edit.set_caret_column(caret_column)
			text_edit.scroll_horizontal = scroll_horizontal
			text_edit.scroll_vertical = scroll_vertical


func _shortcut_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if Input.is_action_pressed(FORMAT_ACTION):
			_on_format_code()
