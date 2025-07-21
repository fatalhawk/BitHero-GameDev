extends CharacterBody2D

const BAT_FRICTION = 200
const KNOCKBACK_DISTANCE = 120
const SOFT_COLLOSION_VELOCITY = 20
const ACCELERATION = 200
const WANDER_ACCERLERATION = ACCELERATION * 0.2
const MAX_SPEED = 50
const BAT_DEATH_EFFECT = preload("res://Effects/batdeatheffect.tscn")

@onready var stats = $Stats
@onready var player_detection = $PlayerRecognition
@onready var sprite = $Bat
@onready var soft_collosion = $SoftCollosions
@onready var start_position = self.global_position

func _ready() -> void:
	self.position.x -= 20

enum {
	IDLE, WANDER, CHASE
}
var state = IDLE

func _physics_process(delta: float) -> void:
	match state:
		IDLE:
			velocity = velocity.move_toward(global_position.direction_to(start_position) * MAX_SPEED, delta * WANDER_ACCERLERATION)
			if seekPlayer():
				state = CHASE
				
		CHASE:
			if player_detection.player != null:
				var direction = (player_detection.player.global_position - self.global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED , ACCELERATION * delta)
			else:
				state = IDLE
	
	if soft_collosion.is_collided():
		velocity += soft_collosion.get_push_vector() * SOFT_COLLOSION_VELOCITY
		
	sprite.flip_h = (velocity.x < 0)
	move_and_slide()
			
func seekPlayer():
	return player_detection.is_player() 

func deathEffect():
	queue_free()
	var death_instance = BAT_DEATH_EFFECT.instantiate()
	
	death_instance.position = self.position
	get_parent().add_child(death_instance)
		
func _on_bat_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = area.knockback_vector * KNOCKBACK_DISTANCE

func _on_stats_no_health() -> void:
	deathEffect()
	queue_free() 
