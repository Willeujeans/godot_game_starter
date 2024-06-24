extends CharacterBody2D

@export var speed: float = 410.0
@export var jump_velocity: float = -400.0
@export var lerp_speed: float = 0.5
@export var friction: float = 16.0
@export var acceleration: float = 100.0

@export_category("†")
@export var can_wall_jump: bool = false
@export var can_double_jump: bool = false
@export var can_crouch: bool = false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_act: bool = true
var facing_right: bool = true
var locked_facing: bool = false
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	fall(gravity, delta)
	if !can_act:
		return
	handle_inputs()
	facing()
	move(delta)
	coyote_timer()


func fall(gravity, delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_inputs():
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or !$CoyoteTimer.is_stopped():
			velocity.y = jump_velocity
	# Move
	direction = Vector2(Input.get_axis("move_left","move_right"), Input.get_axis("move_down","move_up"))
	maximize_directional_input()


func maximize_directional_input():
	if direction.x > 0:
		direction.x = 1
	if direction.x < 0:
		direction.x = -1
	if direction.x == 0:
		direction.x = 0
	direction.normalized()


func facing():
	if locked_facing:
		return
	if direction.x < 0:
		$AnimatedSprite2D.set_flip_h(true)
		facing_right = false
	if direction.x > 0:
		$AnimatedSprite2D.set_flip_h(false)
		facing_right = true


func move(delta):
	$AnimatedSprite2D.play("move")
	if direction.x:
		accelerate(direction)
	else:
		add_friction()


func accelerate(direction):
	velocity.x = move_toward(velocity.x, speed * direction.x, acceleration)


func add_friction():
	velocity.x = move_toward(velocity.x, 0, friction)


func coyote_timer():
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		$CoyoteTimer.start()
