extends Node2D

@onready var playerAnimationTree = $player/AnimationTree

func _ready() -> void:
	playerAnimationTree.set("parameters/idle/blend_position", Vector2(1, 0))

func _on_exit_up_body_entered(body: Node2D) -> void:
	Transition.go_to_scene("res://scenes/final_level.tscn")
