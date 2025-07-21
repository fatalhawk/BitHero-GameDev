extends ProgressBar

@onready var timer = $Timer
@onready var damageBar = $DamageBar

var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health < prev_health:
		timer.start()
	else:
		damageBar.value = health
		
	#if health <= min_value:
		#queue_free()
		
	
	

func init_health(_health):
	health = _health
	max_value = health
	min_value = 0
	value = health
	damageBar.max_value = health
	damageBar.value = health


func _on_timer_timeout() -> void:
	damageBar.value = health
