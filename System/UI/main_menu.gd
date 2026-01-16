extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn") #Change scene path later


func _on_options_pressed() -> void:
	print("TODO")
	#Add line to UI menu wehn finished


func _on_quit_pressed() -> void:
	get_tree().quit()
