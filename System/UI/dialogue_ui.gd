extends CanvasLayer

@onready var portrait = $"Control/Panel/NPC Portrait"
@onready var name_lable = $"Control/Text background/NPC Name"
@onready var text_lable = $"Control/Text background/Dialogue"
@onready var next_button = $"Control/Text background/Next Button"

var lines = []
var current_line: int = 0

func load_dialogue(dialogue_path, portrait_path, char_name):
	var file = FileAccess.open(dialogue_path, FileAccess.READ)
	if !file:
		push_error("Dialogue file not found: " + dialogue_path)
		return
	lines = file.get_as_text().split("\n", false)
	file.close()
	
	portrait.texture = load(portrait_path)
	name_lable.text = char_name
	_show_next_line()
	
func _show_next_line():
	if current_line >= lines.size():
		queue_free()
		return
	text_lable.text = lines[current_line]
	current_line += 1
	
func _on_Button_pressed():
	_show_next_line()


func _on_button_pressed() -> void:
	pass # Replace with function body.
