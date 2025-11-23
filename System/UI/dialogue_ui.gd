extends CanvasLayer

@onready var portrait = $"Control/Panel/NPC Portrait"
@onready var name_lable = $"Control/Text background/NPC Name"
@onready var text_lable = $"Control/Text background/Dialogue"
@onready var next_button = $"Control/Text background/Next Button"

var empty_texture: Texture =  preload("res://Objects/Other/transparent_texture.png")
var npc_texture
var player_name
var NPC_name
var portrait_path

var lines = []
var current_line: int = 0

func load_dialogue(dialogue_text: Array, portrait_path: String, NPC_name_local: String, player_name_local: String = "Player"):
	player_name = player_name_local
	NPC_name = NPC_name_local
	npc_texture = load(portrait_path)
	lines = dialogue_text
	_show_next_line()
	
func _show_next_line():
	if current_line >= lines.size():
		queue_free()
		DialogueManager.finish_dialogue()
		return
	
	#Splits the name lable for the text line
	var temp = lines[current_line].split(":", false, 1)
	var name = temp[0].strip_edges()
	var body = temp[1].strip_edges()
	
	if name.to_lower() == "player":
		portrait.texture = empty_texture
		name = player_name
	elif name.to_lower() == "think":
		portrait.texture = empty_texture
		name = "CHANGE FONT"
	else:
		portrait.texture = npc_texture
	
	name_lable.text = name
	text_lable.text = body
	current_line += 1
	
func _on_Button_pressed():
	_show_next_line()


func _on_button_pressed() -> void:
	pass # Replace with function body.
