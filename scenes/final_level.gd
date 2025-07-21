extends Node2D

@onready var ogre = $Ogre
@onready var player = $player
@onready var introDialog = $IntroDialog
@onready var endDialog = $EndDeathDialog
@onready var girl = $Girl

var isgameended = false

var canAttack = false

func _ready() -> void:
	PlayerStats.health = PlayerStats.MAX_HEALTH
	DialogueManager.process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	if DialogueManager.is_dialog_active:
		get_tree().paused = true
	elif isgameended:
		Transition.go_to_scene("res://scenes/end.tscn")


func _on_intro_dialog_body_entered(body: Node2D) -> void:
	if body == player:
		canAttack = true
		introDialog.queue_free()
		var pos = Vector2(ogre.global_position.x, ogre.global_position.y + 60)
		DialogueManager.start_dialog(pos, ogre.introLines)
		
		

func _on_end_death_dialog_body_entered(body: Node2D) -> void:
	if body == player:
		endDialog.queue_free()
		DialogueManager.start_dialog(girl.global_position, girl.lines)
		isgameended = true

		
