extends Area2D

func is_collided():
	return self.get_overlapping_areas().size() > 0
	
func get_push_vector():
	var areas = self.get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_collided():
		push_vector = areas[0].global_position.direction_to(self.global_position).normalized()
		
	return push_vector
