extends Enemy

@onready var danger_detector_left: RayCast2D = $DangerDetectorLeft
@onready var danger_detector_right = $DangerDetectorRight
@onready var animated_sprite_2d = $AnimatedSprite2D

const WALK_SPEED = 10.0
const RUN_SPEED = 40.0
const FRAME_SPEED_SCALE = 0.5

func _ready():
	randomize()
	animated_sprite_2d.speed_scale = 1.0
	velocity.x = 0
	animated_sprite_2d.play("walk")

func _on_attack_box_component_chase_began(new_direction):
	print("detected")
	animated_sprite_2d.speed_scale += FRAME_SPEED_SCALE
	move_speed = RUN_SPEED
	velocity.x = new_direction * move_speed


func _on_attack_box_component_chase_ended():
	animated_sprite_2d.speed_scale -= FRAME_SPEED_SCALE
	move_speed = WALK_SPEED

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	calculate_move_velocity()
	if velocity.x > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("walk")
	move_and_slide()
	print(velocity.x)

func take_damage(_amount, body) -> void:
	if body.global_position.y > get_node("HurtBoxComponent").global_position.y:
		return
	die()

func calculate_move_velocity() -> void:
	if not danger_detector_left.is_colliding() or (danger_detector_left.is_colliding() and danger_detector_left.get_collider() is Spike):
		velocity.x = move_speed
	elif not danger_detector_right.is_colliding() or (danger_detector_right.is_colliding() and danger_detector_right.get_collider() is Spike):
		velocity.x = -move_speed
	
	if is_on_wall():
		print("get wall normal: ", get_wall_normal())
		velocity.x = get_wall_normal().x * move_speed
