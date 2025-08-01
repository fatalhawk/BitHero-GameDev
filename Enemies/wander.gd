extends Node2D

@onready var timer = $Timer
@export var WANDER_LENGTH = 20
@onready var start_position = global_position

func start_wandering():
	var target_vector = Vector2.ZERO
	if self.global_position == start_position:
		target_vector = start_position.direction_to(Vector2(randi_range(-1, 1), 0) * WANDER_LENGTH)
	
	print(target_vector)
	return target_vector
	
