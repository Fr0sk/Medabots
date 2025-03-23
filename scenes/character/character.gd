class_name Character extends CharacterBody3D

const DEG_60 = 1.0472
const DEG_80 = 1.39626

@export_category("Camera")
@export var mouse_sensitivity := 1
@export var base_fov := 75.0
@export var fov_change := 1.5
@export var camera: Camera3D

@export_category("Movement")
@export var walk_speed := 5.0
@export var sprint_speed := 8.0
@export var jump_velocity := 4.5
var movement_speed := 0.0

@export_category("Head Bob")
@export var frequency := 2.0
@export var amplitude := 0.08
var t_bob := 0.0


@export_category("Interaction")
@export var interactor: Interactor
@export var item_slot: Node3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * mouse_sensitivity * -0.01)
		camera.rotate_x(event.relative.y * mouse_sensitivity * -0.01)
		# Clamp between -40º and 60º
		camera.rotation.x = clamp(camera.rotation.x, -DEG_60, DEG_80)
	
	if Input.is_action_just_pressed("interact"):
		interactor.interact()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Handle sprint.
	if Input.is_action_pressed("sprint"):
		movement_speed = sprint_speed
	else:
		movement_speed = walk_speed

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * movement_speed
			velocity.z = direction.z * movement_speed
		else:
			velocity.x = lerp(velocity.x, direction.x * movement_speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * movement_speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * movement_speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * movement_speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped := clampf(velocity.length(), 0.5, sprint_speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()


func _headbob(time: float) -> Vector3:
	var pos := Vector3.ZERO
	pos.y = sin(time * frequency) * amplitude
	pos.x = cos(time * frequency / 2) * amplitude
	return pos
