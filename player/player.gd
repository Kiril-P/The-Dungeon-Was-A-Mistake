extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const NOCLIP_SPEED = SPEED * 2.0

var noclip: bool = false
var _v_prev: bool = false
var _orig_layer: int
var _orig_mask: int

func _ready() -> void:
	_orig_layer = collision_layer
	_orig_mask = collision_mask

func _physics_process(delta: float) -> void:
	# Toggle noclip with the V key.
	var v_now := Input.is_physical_key_pressed(KEY_V)
	if v_now and not _v_prev:
		noclip = not noclip
		if noclip:
			collision_layer = 0
			collision_mask = 0
			velocity = Vector3.ZERO
		else:
			collision_layer = _orig_layer
			collision_mask = _orig_mask
	_v_prev = v_now

	if noclip:
		# Free-fly (no gravity, no collisions).
		var input_dir := Input.get_vector("left", "right", "forward", "backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		velocity.x = direction.x * NOCLIP_SPEED
		velocity.z = direction.z * NOCLIP_SPEED

		# Up/Down: Space (jump) to go up, Shift to go down.
		if Input.is_action_pressed("jump") or Input.is_physical_key_pressed(KEY_SPACE):
			velocity.y = NOCLIP_SPEED
		elif Input.is_physical_key_pressed(KEY_SHIFT):
			velocity.y = -NOCLIP_SPEED
		else:
			velocity.y = 0

		move_and_slide()
		return

	# Normal movement with gravity and collisions.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
