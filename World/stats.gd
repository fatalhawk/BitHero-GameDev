extends Node2D

@export var MAX_HEALTH = 2
signal no_health
signal health_changed

@onready var health = MAX_HEALTH:
	set(value):
		health = clamp(value, 0, MAX_HEALTH)
		emit_signal("health_changed")
		if health <= 0:
			emit_signal("no_health")
			

		
