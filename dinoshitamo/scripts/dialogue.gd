extends Node2D

signal dialogue_closed

@onready var label = $PanelContainer/VBoxContainer/Label
@onready var yes_button = $PanelContainer/VBoxContainer/HBoxContainer/Button
@onready var no_button = $PanelContainer/VBoxContainer/HBoxContainer/Button2

var yes_outcome: String
var no_outcome: String

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("mouse clicked at: ", event.position)

func _ready() -> void:
	get_tree().paused = true
	
func setup(question: String, yes: String, no: String) -> void:
	yes_outcome = yes
	no_outcome = no
	label.text = question	

func _on_button_pressed() -> void:
	print(yes_outcome)
	get_tree().paused = false
	emit_signal("dialogue_closed")
	queue_free()

func _on_button_2_pressed() -> void:
	print(no_outcome)
	get_tree().paused = false
	emit_signal("dialogue_closed")
	queue_free()
