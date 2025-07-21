extends Control

@onready var heartblocks = $HeartUIEmpty
@onready var heartfull = $HeartUIFilled

func _ready() -> void:
	PlayerStats.connect("health_changed", Callable(self, "update"))
	heartblocks.size.x = heartblocks.size.x * PlayerStats.MAX_HEALTH
	heartfull.size.x = heartblocks.size.x
	
func update():
	heartfull.size.x = 15 * PlayerStats.health	
	
