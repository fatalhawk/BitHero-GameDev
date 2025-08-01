extends AnimatedSprite2D

func _ready() -> void:
	self.connect("animation_finished", Callable(self, "animated"))
	play("default")
	
func animated():
	queue_free()
