extends Node

@onready var text_box_scene = preload("res://UI/text_box.tscn")

var dialog_lines : Array[String] = []
var current_line_index = 0

var text_box
var text_box_pos = false

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position: Vector2, lines: Array[String]):
	is_dialog_active = true
	dialog_lines = lines
	text_box_pos = position
	show_text_box()
	
	
	
func show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(on_text_box_finished_displaying)
	text_box.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(text_box)
	text_box.global_position = text_box_pos
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false
	
func on_text_box_finished_displaying():
	can_advance_line = true
	
func _input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("ui_accept") &&
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			get_tree().paused = false
			return
			
		show_text_box()
