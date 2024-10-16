extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var health = $Health

const SPEED = 300.0
const JUMP_VELOCITY = -400.0 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dead: bool =false

func _ready():
	animation_player.play("idle")

func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if dead:
		if velocity.x != 0:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	# Flip animation
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func health_update(amount: int):
	health.update_amount(amount)

func _on_health_death():
	dead = true
	animation_player.play("dead")

func _on_health_revive(_amount, _health):
	dead = false
	animation_player.play("revive")
