extends Area3D

@export_file("*.png") var portrait
@export var character_name: String = "NPC"
@export var sprite: AnimatedSprite3D

var player_in_range: bool = false

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_area_enter"))
	connect("body_exited", Callable(self, "_on_area_exit"))
	
	if sprite and sprite.sprite_frames:
		if sprite.sprite_frames.has_animation("idel"):
			sprite.play("idel")
		
func _on_area_enter(body):
	if body.name == "Player":
		player_in_range = true
		body.current_npc = self
		if sprite:
			if sprite.sprite_frames.has_animation("wave"):  #Or whatever animation to play when able to talk to player
				sprite.play("wave")

func _on_area_exit(body):
	if body.name == "Player":
		player_in_range = false
		body.current_npc = null
		if sprite:
			if sprite.sprite_frames.has_animation("idel"):
				sprite.play("idel")
