extends Camera3D

@export var player: CharacterBody3D
@export var target: Node3D
@export var offset = Vector3(0, 1, -1)
@export var smooth_speed = 100.0
@export var mode: int = 0

var desired_position: Vector3

#This is fucking ugly --- FIX LATER
func _process(delta: float) -> void:
	if mode == 0:
		if !player:
			return
		desired_position = player.global_transform.origin
			
	
	if mode == 1:
		if !target:
			return
		desired_position = target.global_transform.origin
			
	global_transform.origin = global_transform.origin.move_toward(desired_position + offset, smooth_speed * delta)
	look_at(desired_position, Vector3.UP)
