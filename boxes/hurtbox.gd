extends Area2D

const DAMAGE_EFFECT = preload("res://Effects/damageeffect.tscn")
@export var Hit_Effect = true
@export var invincibility_duration = 0.0

@onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

var invincibility = false

func _process(_delta: float) -> void:
	if invincibility:
		set_deferred("monitoring", false)
	else:
		set_deferred("monitoring", true)
		
func damage_effect():
	var effect = DAMAGE_EFFECT.instantiate()
	var main = get_tree().current_scene
	
	
	effect.position = self.global_position
	main.add_child(effect)
	
func start_invincibility(duration):
	invincibility = true
	emit_signal("invincibility_started")
	timer.start(duration)
	
func _on_area_entered(_area: Area2D) -> void:
	if !invincibility:
		if Hit_Effect:
			damage_effect()
		if invincibility_duration > 0:
			start_invincibility(invincibility_duration)
	

func _on_timer_timeout() -> void:
	invincibility = false
	emit_signal("invincibility_ended")
	
