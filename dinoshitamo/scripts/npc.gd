extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 1

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_loctation = nav_agent.get_next_path_position()
	var new_velocity = (next_loctation  - current_location).normalized() * SPEED 

	nav_agent.set_velocity(new_velocity)

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func _on_navigation_agent_3d_target_reached() -> void:
	print("in range")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 1)
	move_and_slide()
