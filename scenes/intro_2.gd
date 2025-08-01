extends Node2D

@onready var oldhag = $OldHag
@onready var player = $player
@onready var playerAnimationTree = $player/AnimationTree

func _ready() -> void:
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
	playerAnimationTree.set("parameters/idle/blend_position", Vector2(0, -1))

func _physics_process(delta: float) -> void:
	if (DialogueManager.is_dialog_active):
		print("paused")
		get_tree().paused = true


func _on_old_hag_listening_body_entered(body: Node2D) -> void:
	if (body == player):
		var pos = Vector2(oldhag.global_position.x + 40, oldhag.global_position.y+40)
		DialogueManager.start_dialog(pos, oldhag.lines)


func _on_exit_up_body_entered(body: Node2D) -> void:
	Transition.go_to_scene("res://scenes/level_1.tscn")
