extends Control

@onready var image_rect: TextureRect = $Background/ItemRect

var image_texture: Texture2D

func set_image(image_path: String):
	print("ITEM UI")
	print(image_path)
	if image_path == "":
		image_rect.texture = null
		visible = false
		return
		
	image_texture = load(image_path)
	image_rect.texture = image_texture
	visible = true
	print("Loaded texture", image_texture)
