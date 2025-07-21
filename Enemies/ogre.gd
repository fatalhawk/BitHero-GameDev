extends CharacterBody2D

const FRICTION = 400
const ACCELERATION = 200
const MAX_SPEED = 60
#const ROLL_SPEED = MAX_SPEED * 2	
const ATTACK_FACTOR = 0.85
const SOFT_COLLOSION_VELOCITY = 5

enum {MOVE, ATTACK, OG_ATTACK, DEATH}
var state = MOVE  #default state
var health
var is_alive
var canAttack = true
var og_attack_done = false
const introLines : Array[String] = ["Who are you ?", "NO TRESPASSING !!"]
const midLines : Array[String] = ["You son of a ...!!!!!"]
#var roll_vector = Vector2.ZERO

@export var og_attack_duration = 10

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var blink_player = $BlinkAnimation
@onready var swordhitbox = $HitboxPivot/OgreSwordHitbox
@onready var sword_collosion_box = $HitboxPivot/OgreSwordHitbox/CollisionShape2D
@onready var hurtbox = $hurtbox
@onready var hurtbox_collosionshape = $hurtbox/CollisionShape2D
@onready var timer = $Timer
@onready var attackTimer = $HitboxPivot/OgreSwordHitbox/AttackTimer
@onready var player_detection = $PlayerRecognition
@onready var soft_collosion = $SoftCollosions
@onready var player = $"../player"
@onready var healthBar = $CanvasLayer/HealthBar
@onready var finalscene = $".."
@onready var bars = $"../bars"
@onready var ogreHealth = $CanvasLayer
@onready var bgmusic = $"../AudioStreamPlayer"


func _ready() -> void:
	ogreHealth.visible = false
	hurtbox_collosionshape.disabled = true
	health = 12
	is_alive = true
	print("its ready")

	
	healthBar.init_health(health)
	#PlayerStats.connect("no_health", Callable(self, "queue_free"))
	animation_tree.active = true
	animation_tree.set("parameters/idle/blend_position", Vector2(0,1))
	
func _physics_process(delta):
	if finalscene.canAttack:
		ogreHealth.visible = true
		hurtbox_collosionshape.disabled = false
		match state:
			MOVE:
				move_state(delta)
			ATTACK:
				attack_state(delta)
			OG_ATTACK:
				og_attack(delta)
			DEATH:
				death_state()
	
	if soft_collosion.is_collided():
		velocity += soft_collosion.get_push_vector() * SOFT_COLLOSION_VELOCITY
		
		
	
func move_state(delta):
	if velocity != Vector2.ZERO:
		set_direction()
		animation_state.travel("run")
		#bug is slight up and down press makes the character turn to left or right, cos of run blender positon y is set to 1.1
	if player != null:
		var direction = (player.global_position - self.global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED , ACCELERATION * delta)
	
	if player_detection.is_player() && canAttack:
		swordhitbox.knockback_vector = animation_tree.get("parameters/attack/blend_position").normalized() 
		state = ATTACK
	
	if health <= (healthBar.max_value / 2) && !og_attack_done:
		DialogueManager.start_dialog(self.global_position, midLines)
		state = OG_ATTACK
	#if Input.is_action_just_pressed("evade"):
		#state = OG_ATTACK
	
	move_and_slide()
		
	
func set_direction():
	animation_tree.set("parameters/run/blend_position", velocity)
	animation_tree.set("parameters/idle/blend_position", velocity)
	animation_tree.set("parameters/attack/blend_position", velocity)	
	
func attack_state(_delta):
	if canAttack:
		velocity *= ATTACK_FACTOR
		canAttack = false
		attackTimer.start(swordhitbox.cooldown_duration)
		animation_state.travel("attack")
		move_and_slide()
	
func _on_attack_timer_timeout() -> void:
	canAttack = true
		
func og_attack(delta):
	if velocity != Vector2.ZERO:
		set_direction()
		#bug is slight up and down press makes the character turn to left or right, cos of run blender positon y is set to 1.1
	if player != null:
		var direction = (player.global_position - self.global_position).normalized()
		velocity = velocity.move_toward(direction * MAX_SPEED , ACCELERATION * delta)
		
	if timer.is_stopped():
		print("playing animation")
		timer.start(og_attack_duration)
		animation_state.travel("og_attack")
	
	#var input_vector = Vector2.ZERO
	#input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	#input_vector = input_vector.normalized()
	
	#if input_vector != Vector2.ZERO:
		#velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	move_and_slide()
	
func _on_timer_timeout() -> void:
	og_attack_done = true
	animation_player.stop()
	sword_collosion_box.set_deferred("disabled", true)
	animation_state.travel("idle")
	state = MOVE

func attack_end():
	state = MOVE

func death_state():
	is_alive = false
	var direct = animation_tree.get("parameters/idle/blend_position")
	animation_tree.set('parameters/death/blend_position', direct)
	bgmusic.stop()
	hurtbox_collosionshape.disabled = true
	animation_state.travel("death")
	
func death_end():
	bars.queue_free()
	queue_free()
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if health <= 0:
		state = DEATH
	if is_alive:
		health -= area.damage
		healthBar.health = health
	


func _on_hurtbox_invincibility_started() -> void:
	blink_player.play("start")


func _on_hurtbox_invincibility_ended() -> void:
	blink_player.play("end")
