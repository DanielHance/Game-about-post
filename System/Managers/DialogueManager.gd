extends Node

var dialogue_ui = preload("res://System/UI/Dialogue_UI.tscn")
var instance

func start_dialogue(dialogue_path: String, portrait_path: String, name: String):
	if instance:
		instance.queue_free()
	instance = dialogue_ui.instantiate()
	get_tree().root.add_child(instance)
	instance.load_dialogue(dialogue_path, portrait_path, name)
