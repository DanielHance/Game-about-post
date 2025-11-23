extends Node

var dialogue_ui = preload("res://System/UI/Dialogue_UI.tscn")
var button_ui = preload("res://System/UI/buttons_ui.tscn")
var instance_ui
var instance_button

var file_paths = [
		"res://Script/prolog.txt",
		"res://Script/menu.txt",
		"res://Script/vampire.txt",
		"res://Script/love_letter.txt",
		"res://Script/graveyard.txt",
		"res://Script/lighthouse.txt"
	]

var score: int = 0  #This varable sucks and should be changed at a later data!!!!
var button_locks = [] 
var text_files = []
var current_script: int = 0
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
	
	if score == 4:
		print("Finished")
		#Do something 
	
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
				if line.to_lower().begins_with("!script"):
					parts = line.split("=", false, 1)
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
					print(line)
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
				elif line.to_lower().begins_with("!score"):
					score += 1
				elif ":" in line:
					parts = line.split(":", false, 1)
					if parts[0].strip_edges().to_lower() == "player" or parts[0].strip_edges().to_lower() == NPC_name.to_lower() or parts[0].strip_edges().to_lower() == "think":
						lines.append(line)
					else:
						#Stop adding text
						line_marker = i
						break
				else:
					push_error("Invalid text on line ", i, " in ", file_paths[current_script])
	
	print("Lanch")
	_start_dialogue(lines, portrait_path, player_name, NPC_name)
	
func button_return(callback: String, callbacks: Array):
	#This line sucks and should be change at some point 
	if current_script == 1:
		button_locks.append(callbacks.find(callback))
		
	if callback.is_valid_int():
		current_branch = int(callback)
		line_marker += 1
	else:
		print(file_paths.find("res://Script/" + callback.to_lower().strip_edges()))
		current_script = file_paths.find("res://Script/" + callback.to_lower().strip_edges())
		current_branch = 0
		line_marker = 0
	text_flag = true
	finish_dialogue()
	
func finish_dialogue():
	if button_flag:
		_get_button_data()
	if text_flag:
		text_flag = false
		dialogue(NPC_name, portrait_path, player_name)
		
func _get_button_data():
	print("Button flag is true")
	#Get button options from line and send to button script
	button_flag = false
	var temp = text_files[current_script][line_marker].split(":", false)
	var data = temp[1].split(",", false)
	if len(data) == 0:
		push_error("Something is wrong with !buttons on line", line_marker)
	var lables: Array[String] = [] #Need long def or everything breaks >:(
	var callbacks: Array = []
	var part
	for i in range(len(data)):
		if i not in button_locks:  
			part = data[i].split("=", false, 1)
			lables.append(part[0].strip_edges())
			callbacks.append(part[1].strip_edges().to_lower())
	_start_dialogue_buttons(lables, callbacks)
		
func unlock():
	lock = false
	print("Lock is off")

func _start_dialogue(dialogue_text: Array, portrait_path: String, player_name: String, NPC_name: String):
	if instance_ui:
		instance_ui.queue_free()
	instance_ui = dialogue_ui.instantiate()
	get_tree().root.add_child(instance_ui)
	instance_ui.load_dialogue(dialogue_text, portrait_path, player_name, NPC_name)
	
func _start_dialogue_buttons(button_lables: Array[String], button_branches: Array):
	if instance_button:
		instance_button.queue_free()
	instance_button = button_ui.instantiate()
	get_tree().root.add_child(instance_button)
	instance_button.show_buttons(button_lables, button_branches)
