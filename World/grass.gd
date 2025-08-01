extends Node2D

const  GRASS_EFFECT = preload("res://Effects/grasseffect.tscn")

func grassEffect():
	queue_free()		
	var grass_instance = GRASS_EFFECT.instantiate()
	
	grass_instance.position = self.position
	get_parent().add_child(grass_instance)
		
func _on_hurtbox_area_entered(_area: Area2D) -> void:
	grassEffect()
	queue_free()
