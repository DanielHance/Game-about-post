extends Node

var dialogue_ui = preload("res://System/UI/Dialogue_UI.tscn")
var button_ui #= preload("res://System/UI/Button_UI.tscn")
var instance_ui
var instance_button

var file_paths = [
		"res://Script/test.txt",
		"res://Script/prolog.txt",
		"res://Script/vampire.txt"
	]

var text_files = []
var current_script: int = 2
var current_branch: int = 0
var temp_NPC
var line_marker: int = 0
var lock: bool = false
var button_flag = false
var text_flag = false

var NPC_name
var portrait_path
var player_name

func _ready():
	for i in range(file_paths.size()):
		var path = file_paths[i]
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			text_files.append(file.get_as_text().split("\n", false))
			file.close()
		else:
			push_error("Text file: " + path + " could not be laoded!" )


func dialogue(NPC_name_local: String, portrait_path_local: String, player_name_local: String):
	var lines = []
	var parts 
	var sub_parts
	var line
	var line_branch = current_branch
	NPC_name = NPC_name_local
	portrait_path = portrait_path_local
	player_name = player_name_local
	print("Start")
	print("Script = ", current_script)
	
	if lock:
		return
	
	for i in range(line_marker, text_files[current_script].size()):
		line = text_files[current_script][i]
		
		#Checks line is not a comment
		if line[0] != "#":
			
			#Check branch command ahs been called
			if line.to_lower().begins_with("!branch"):
				#Update line's branch
				if "-" in line:
					parts = line.split("-", false, 1)
					line_branch = int(parts[1].strip_edges())
				#Updates current branch
				elif "=" in line:
					parts = line.split("=", false, 1)
					current_branch = int(parts[1].strip_edges())
				
			if line_branch == current_branch:
				#Checks if script command has been called
				if line.to_lower().begins_with("!scrip"):
					parts = line.split("=", false, 1)
					print(parts[1].to_lower())
					current_script = file_paths.find("res://Script/" + parts[1].to_lower().strip_edges())
					current_branch = 0
					line_marker = 0
					if current_script == -1:
						push_error("Invalid script") #Think the error detection is broken so don't make any errors
					
					break
					
				#Check if button command has been called
				elif line.to_lower().begins_with("!button"):
					button_flag = true
					line_marker = i
					break
					
				#Checks if choice command has been called
				elif line.to_lower().begins_with("!choice"):
					if lines.size() != 0:
						line_marker = i
						break
					parts = line.split(":", false, 1)
					parts = parts[1].split(",", false)
					var temp = true
					for j in range(parts.size()):
						sub_parts = parts[j].split("=", false, 1)
						if sub_parts[0].strip_edges().to_lower() == NPC_name.to_lower():
							current_branch = int(sub_parts[1].strip_edges())
							line_branch = current_branch
							temp = false
							break
					if temp:
						break
				
				#Check if lock command has been called
				elif line.to_lower().begins_with("!lock"):
					if lines.size() != 0:
						lock = true
						line_marker = i
						print("Locked is on")
						break
					
				elif ":" in line:
					parts = line.split(":", false, 1)
					if parts[0].strip_edges().to_lower() == "player" or parts[0].strip_edges().to_lower() == NPC_name.to_lower():
						lines.append(line)
					else:
						#Stop adding text
						line_marker = i
						break
				else:
					push_error("Invalid text on line ", i, " in ", file_paths[current_script])
	
	print("Lanch")
	_start_dialogue(lines, portrait_path, player_name, NPC_name)
	
func finish_dialogue():
	if button_flag:
		print("lanch buttons")
		button_flag = false
	if text_flag:
		dialogue(NPC_name, portrait_path, player_name)
		text_flag = false
		
func unlock():
	lock = false
	print("Lock is off")

func _start_dialogue(dialogue_text: Array, portrait_path: String, player_name: String, NPC_name: String):
	if instance_ui:
		instance_ui.queue_free()
	instance_ui = dialogue_ui.instantiate()
	get_tree().root.add_child(instance_ui)
	instance_ui.load_dialogue(dialogue_text, portrait_path, player_name, NPC_name)
	
func _start_dialogue_buttons(button_lables: Array, button_branches: Array):
	print("BUTTONS - TODO")
	return
	#if instance_button:
		#instance_button.queue_free()
	#instance_button = button_ui.instantiate() 
	#get_tree().root.add_child(button_ui)
	#instance_button.load_dialogue(dialogue_path, portrait_path)
	
	#Need to add a !drop comand that will allow the player to drop the parcel and change the branch
	#Also need to fix the button actiavtion code as at the moment if it create an infinate loop
