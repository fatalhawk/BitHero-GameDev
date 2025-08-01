extends CharacterBody2D

const FRICTION = 400
const ACCELERATION = 200
const MAX_SPEED = 60
const ROLL_SPEED = MAX_SPEED * 2	
const ATTACK_FACTOR = 0.85
const KNOCKBACK_DISTANCE = 120
const SOFT_COLLOSION_VELOCITY = 5


enum {MOVE, ATTACK, ROLL}
var state = MOVE  #default state
var roll_vector = Vector2.ZERO

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var blink_player = $BlinkAnimation
@onready var swordhitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $hurtbox
@onready var soft_collosion = $SoftCollosions


func _ready() -> void:
	print("its ready")
	print(hurtbox.invincibility)
	PlayerStats.connect("no_health", Callable(self, "on_death"))
	animation_tree.active = true
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)
			
	if soft_collosion.is_collided():
		velocity += soft_collosion.get_push_vector() * SOFT_COLLOSION_VELOCITY
		
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", input_vector)
		animation_tree.set("parameters/run/blend_position", input_vector)
		animation_tree.set("parameters/attack/blend_position", input_vector)
		animation_tree.set("parameters/roll/blend_position", input_vector)
		
		animation_state.travel("run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if Input.is_action_just_pressed("action"):
		swordhitbox.knockback_vector = animation_tree.get("parameters/attack/blend_position")
		state = ATTACK
		
	if Input.is_action_just_pressed("evade"):
		roll_vector = input_vector
		state = ROLL
		
	move_and_slide()
	
func attack_state(_delta):
	velocity *= ATTACK_FACTOR
	move_and_slide()
	animation_state.travel("attack")
	
func roll_state(_delta):
	hurtbox.invincibility = true
	velocity = roll_vector * ROLL_SPEED	
	move_and_slide()
	animation_state.travel("roll")
	
	
func roll_end():
	velocity = velocity / ROLL_SPEED
	hurtbox.invincibility = false
	state = MOVE
	
func attack_end():
	state = MOVE

	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	PlayerStats.health -= area.damage
	print(area)
	velocity = area.knockback_vector * KNOCKBACK_DISTANCE


func _on_hurtbox_invincibility_started() -> void:
	blink_player.play("start")


func _on_hurtbox_invincibility_ended() -> void:
	blink_player.play("end")
	
func on_death():
	Transition.go_to_scene("res://scenes/game_over.tscn")
	queue_free()
	
