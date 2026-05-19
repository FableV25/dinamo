extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = .5
var target_set = false
var player_in_range = false
var origin: Vector3  # store starting position

func _ready() -> void:
	origin = global_transform.origin  # save it on start

func _physics_process(delta):
	if not target_set:
		return
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	nav_agent.set_velocity(new_velocity)

func update_target_location(target_location):
	if not player_in_range:
		return
	if nav_agent.target_position.distance_to(target_location) > 0.1:
		target_set = true
		nav_agent.set_target_position(target_location)

func _on_navigation_agent_3d_target_reached() -> void:
	if target_set and not player_in_range:
		# reached origin, stop moving
		target_set = false
		velocity = Vector3.ZERO

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 1)
	move_and_slide()

func _on_detection_zone_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	print("body entered: ", body.name, " groups: ", body.get_groups())
	if body.is_in_group("player"):
		player_in_range = true


func _on_detection_zone_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		target_set = true
		nav_agent.set_target_position(origin)  # go back home
