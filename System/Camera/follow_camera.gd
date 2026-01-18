extends Camera3D

@export var player: CharacterBody3D
@export var target: Node3D
@export var offset = Vector3(0, 1.5, -2)
@export var smooth_speed = 10.0
@export var mode = 0  # 0 = player, 1 = target

@onready var raycast: RayCast3D = $RayCast3D

func _ready():
	if player:
		raycast.add_exception(player)

func _physics_process(delta: float) -> void:
	var focus_point: Vector3

	#Sets up mode
	if mode == 0:
		if !player: return
		focus_point = player.global_position
	elif mode == 1:
		if !target: return
		focus_point = target.global_position
	else:
		return

	# Desired camera position
	var desired_camera_pos = focus_point + offset

	#Ray casting Stuff
	raycast.global_position = focus_point
	raycast.target_position = raycast.to_local(desired_camera_pos)  # Convert world to local (THIS LINE TOOK ME 1 HOUR TO FIX!!!)
	raycast.force_raycast_update()

	var final_camera_pos = desired_camera_pos

	if raycast.is_colliding():
		final_camera_pos = raycast.get_collision_point() - (desired_camera_pos - focus_point).normalized() * 0.1

	# Smooth camera movement
	var t = 1.0 - pow(0.001, delta * smooth_speed)  # smoother than move_toward
	global_position = global_position.lerp(final_camera_pos, t)

	# Look at the focus point
	look_at(focus_point, Vector3.UP)
