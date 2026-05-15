extends Node3D


func _on_op_1_button_down() -> void:
	CharacterSelcetorThing.active_Charcter = "p1"
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_op_2_button_down() -> void:
	CharacterSelcetorThing.active_Charcter = "p2"
	get_tree().change_scene_to_file("res://scenes/main.tscn")
