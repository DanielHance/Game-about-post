extends Control

@onready var bg = $ColorRect
@onready var container = $VBoxContainer

var normal_tex = preload("res://UI/ButtonEmpty.png")
var hover_tex = preload("res://UI/EmptyButtonHover.png")
var pressed_tex = preload("res://UI/EmptyButtonHover.png")
var button_font = preload("res://UI/PTSerif-Regular.ttf")

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
	var button_height = container.size.y / 5
	#container.spacing = 16
	
	#Create each button
	for i in range(count):
		
		#Create button
		var button := Button.new()
		button.text = _options[i]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_FILL
		button.custom_minimum_size = Vector2(0, button_height)  # fix height per button
		button.focus_mode = Control.FOCUS_ALL
		button.add_theme_font_override("font", button_font)
		
		#Create and apply style box (texture) Next time just use texture buttons :/
		var normal_style = StyleBoxTexture.new()
		normal_style.texture = normal_tex
		button.add_theme_stylebox_override("normal", normal_style)
		var hover_style = StyleBoxTexture.new()
		hover_style.texture = hover_tex
		button.add_theme_stylebox_override("hover", hover_style)
		var pressed_style = StyleBoxTexture.new()
		pressed_style.texture = pressed_tex
		button.add_theme_stylebox_override("pressed", pressed_style)
		
		#Adds click functionality
		button.pressed.connect(_on_option_pressed.bind(i))
		
		container.add_child(button)
		
func _on_option_pressed(index: int) -> void:
	#Send option selected back to dialogue manager
	DialogueManager.button_return(_callback[index], _callback)
	queue_free()
