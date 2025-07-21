extends Node2D

func _input(event):
	# Check if any keyboard key is pressed
	if event is InputEventKey and event.pressed:
		Transition.go_to_scene("res://scenes/intro_1.tscn")

	# Check if any mouse button is pressed
	if event is InputEventMouseButton and event.pressed:
		Transition.go_to_scene("res://scenes/intro_1.tscn")
