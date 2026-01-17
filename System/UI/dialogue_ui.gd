extends Control

@onready var portrait = $"Panel/AspectRatioContainer/NPC Portrait"
@onready var name_lable = $"Text background/NPC Name"
@onready var text_lable = $"Text background/Dialogue"
@onready var next_button = $"Text background/Next Button"
@onready var text_sound: AudioStreamPlayer2D = $"Text Sound"

var defult_font = preload("res://UI/PTSerif-Regular.ttf")
var thinking_font = preload("res://UI/PTSerif-Italic.ttf")


#Pre-load font and stuff
var empty_texture: Texture =  null
var npc_texture
var player_name
var NPC_name
var portrait_path

var lines = []
var current_line: int = 0

#Below is for the word appearing one at a time 
@export var letter_speed = 0.05
var letters = ""
var letter_index = 0
var elapsed = 0
var is_typing  = false

@export var pitch = 1.2
var letter_sounds: Dictionary = {}

func _ready():
	#Load letter sounds
	for i in range(26):
		var letter_name = char(65 + i)
		var path = "res://Sound/Letter Speach Sounds/%s.wav" % letter_name
		letter_sounds[letter_name] = load(path)

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
	
	text_lable.add_theme_font_override("normal_font", defult_font)
	name_lable.add_theme_font_override("normal_font", defult_font)
	if name.to_lower() == "player":
		portrait.texture = empty_texture
		name = ""
	elif name.to_lower() == "think":
		portrait.texture = empty_texture
		name = ""
		text_lable.add_theme_font_override("normal_font", thinking_font)
		name_lable.add_theme_font_override("normal_font", thinking_font)
	else:
		portrait.texture = npc_texture
	
	name_lable.text = name
	
	letters = body
	letter_index = 0
	elapsed = 0.0
	text_lable.text = ""
	is_typing = true
	
	current_line += 1
	
	
#Timer that controls speed words appear at
func _process(delta):
	if not is_typing:
		return
		
	elapsed += delta
	if elapsed >= letter_speed and letter_index < letters.length():
		elapsed = 0.0
		
		var letter = letters[letter_index]
		text_lable.text += letter
		letter_index += 1
		
		#Skips delay on punchuation
		if letter in ".!?,":
			elapsed += letter_speed
		
		if letter.to_upper() in letter_sounds:
			text_sound.stream = letter_sounds[letter.to_upper()] 
			text_sound.pitch_scale = pitch + randf_range(-0.05, 0.05)
			text_sound.play()
		
	if letter_index >= letters.length():
		is_typing = false


func _on_next_button_pressed() -> void:
	if is_typing:
		text_lable.text = letters
		is_typing = false
		return
	_show_next_line()
