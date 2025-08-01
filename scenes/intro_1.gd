extends Node2D

@onready var player = $player
@onready var playerAnimationTree = $player/AnimationTree

const lines : Array[String] = ["Help....help!!!"]
const exitlines : Array[String]= ["Someone needs my help!!"]
var isDialogActive = false

func _ready() -> void:
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS
	playerAnimationTree.set("parameters/idle/blend_position", Vector2(-1, 0))
	
func _physics_process(delta: float) -> void:
	if (DialogueManager.is_dialog_active):
		get_tree().paused = true


func _on_help_dialog_body_entered(body: Node2D) -> void:
	if (body == player):
		DialogueManager.start_dialog(Vector2(205, player.global_position.y - 50), lines)


func _on_exit_body_entered(body: Node2D) -> void:
	if body == player:
		var pos = Vector2(player.global_position.x + 40, player.global_position.y)
		DialogueManager.start_dialog(pos, exitlines)


func _on_exit_up_body_entered(body: Node2D) -> void:
	Transition.go_to_scene("res://scenes/intro_2.tscn")
