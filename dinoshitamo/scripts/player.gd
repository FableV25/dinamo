extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var camera_marker: Marker3D = $CameraMarker
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var p1 = preload("res://scenes/ai_main.tscn")
@onready var p2 = preload("res://models/Child.fbx")

const SPEED = 1.0

const ZOOM_SPEED = 15
const ZOOM_MIN = 2.0
const ZOOM_MAX = 25.0
var zoom_target := 10.0

var player_mesh: Node3D  # reference to the visual model
var anim_player_idle: AnimationPlayer
var anim_player_walk: AnimationPlayer

func _ready() -> void:
	add_to_group("player")
	camera_3d.global_position = camera_marker.global_position
	if CharacterSelcetorThing.active_Charcter == "p1":
		player_mesh = p1.instantiate()
	else:
		player_mesh = p2.instantiate()
	add_child(player_mesh)
	player_mesh.rotation_degrees.y = 180
	anim_player_idle = player_mesh.get_node("AnimationPlayer")
	anim_player_walk = player_mesh.get_node("walk")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				set_nav_target()
			MOUSE_BUTTON_WHEEL_UP:
				zoom_target -= ZOOM_SPEED
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom_target += ZOOM_SPEED

	zoom_target = clamp(zoom_target, ZOOM_MIN, ZOOM_MAX)

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Navigation movement
	if not navigation_agent_3d.is_navigation_finished():
		var next_path_point := navigation_agent_3d.get_next_path_position()
		var new_velocity := (next_path_point - global_position).normalized() * SPEED
		velocity.x = new_velocity.x
		velocity.z = new_velocity.z
		look_at_path(next_path_point)
		anim_player_walk.play("Armature|walking_man|baselayer")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim_player_idle.play("Armature|clip0|baselayer")

	move_and_slide()

	# Smooth zoom
	camera_marker.position.z = lerp(camera_marker.position.z, zoom_target, delta * 8.0)

	# Smooth camera follow
	camera_3d.global_position = lerp(
		camera_3d.global_position,
		camera_marker.global_position,
		delta * 2.5)

func set_nav_target() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100.0
	var from = camera_3d.project_ray_origin(mouse_pos)
	var to = from + camera_3d.project_ray_normal(mouse_pos) * ray_length

	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.create(from, to)

	var result = space.intersect_ray(ray_query)
	if result:
		navigation_agent_3d.target_position = result.position

func look_at_path(target: Vector3) -> void:
	if not player_mesh:
		return
	var direction = Vector3(target.x, player_mesh.global_position.y, target.z)
	player_mesh.look_at(direction, Vector3.UP)
	player_mesh.rotation_degrees.y += 180
	
