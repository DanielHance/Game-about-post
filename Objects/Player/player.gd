extends CharacterBody3D

@export var speed = 5.0
@export var sprite_sheet: SpriteFrames

var sprite: AnimatedSprite3D
var front_vec: Vector3 = Vector3(0, 0, -1)
var input_vec = Vector3.ZERO
var face_vec: Vector3 = Vector3(0, 0, -1)
var current_npc: Area3D = null

func _ready() -> void:
	sprite = $AnimatedSprite3D

func _process(delta: float) -> void:
	#Input Handling 
	input_vec = Vector3.ZERO
	if Input.get_action_strength("move_right"):
		input_vec.x -= 1
	elif Input.get_action_strength("move_left"):
		input_vec.x += 1
	elif Input.get_action_strength("move_up"):
		input_vec.z += 1
	elif Input.get_action_strength("move_down"):
		input_vec.z -= 1
		
	input_vec = input_vec.normalized() #Just to be safe
	
func _physics_process(delta: float) -> void:
	#------------------------------------Movement
	velocity = input_vec * speed
	move_and_slide()
	look_at(global_transform.origin + front_vec, Vector3.UP)
	
	#-----------------------------------Animation
	var frame_name = ""
	
	if input_vec != Vector3.ZERO:
		frame_name = "walk_"
		face_vec = input_vec
	else:
		frame_name = "idel_"
		
	if face_vec.z > 0:
		frame_name += "up"
	elif face_vec.z < 0:
		frame_name += "down"
	elif face_vec.x < 0:
		frame_name += "left"
	elif face_vec.x > 0:
		frame_name += "right"
		
	sprite.sprite_frames = sprite_sheet
	sprite.play(frame_name)
	
	#---------------------------------------NPC Interactions 
	if Input.is_action_just_pressed("interact") and current_npc:
		DialogueManager.start_dialogue(
			current_npc.dialogue_file,
			current_npc.portrait,
			current_npc.character_name
		)
		print("Working")
		
	
	
	
