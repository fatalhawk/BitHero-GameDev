extends Node2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		Transition.go_to_scene("res://scenes/controls.tscn")
