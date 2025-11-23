extends Control

@onready var bg = $ColorRect
@onready var container = $VBoxContainer

var _callback: Array = []
var _options: Array[String] = []

func show_buttons(options: Array[String], callback: Array) -> void:
	_options = options
	_callback = callback
	
	_build_buttons()
	
func _build_buttons()-> void:
	#Remove existing buttons
	for child in container.get_children():
		child.queue_free()
		
	#Adds gaps between buttons
	var count = clamp(_options.size(), 1, 4)
	#container.spacing = 16
	
	#Create each button
	for i in range(count):
		var button := Button.new()
		button.text = _options[i]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.focus_mode = Control.FOCUS_ALL
		
		#Adds click functionality
		button.pressed.connect(_on_option_pressed.bind(i))
		
		container.add_child(button)
		
func _on_option_pressed(index: int) -> void:
	#Send option selected back to dialogue manager
	DialogueManager.button_return(_callback[index], _callback)
	queue_free()
