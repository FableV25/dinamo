extends Node3D

@export var target_scene: String = "res://scenes/centro_test.tscn"  # change per gate

var player_inside = false
var label: Label

func _ready() -> void:
	# create the "press E" label
	label = Label.new()
	label.text = "Hold E to travel"
	label.visible = false
	# add it to a CanvasLayer so it shows on screen
	var canvas = CanvasLayer.new()
	canvas.add_child(label)
	add_child(canvas)
	# position it in the middle of the screen
	label.set_anchors_preset(Control.PRESET_CENTER)

func _process(delta) -> void:
	if player_inside and Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file(target_scene)
 
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = true
		label.visible = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_inside = false
		label.visible = false
