extends CharacterBody3D

# === CONFIGURABLE CONSTANTS ===
const BASE_SPEED: float = 5.0
const AIR_SPEED: float = 3.5    
const CROUCH_AIR_SPEED: float = 2.0   
const SPRINT_MULTIPLIER: float = 2.0
const CROUCH_SPEED: float = 2.5
const STAND_JUMP_VELOCITY: float = 4.5
const CROUCH_JUMP_VELOCITY: float = 3.0
const NOCLIP_SPEED: float = 20.0

const CROUCH_HEIGHT: float = 0.25
const STAND_HEIGHT: float = 2.0
const CROUCH_LERP_SPEED: float = 10.0

# === STATE VARIABLES ===
var speed: float = BASE_SPEED
var noclip: bool = false
var crouching: bool = false
var _v_pressed_last_frame: bool = false

# Collision setup
var _original_collision_layer: int
var _original_collision_mask: int

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var _target_height: float = collision_shape.shape.height


func _ready() -> void:
	_original_collision_layer = collision_layer
	_original_collision_mask = collision_mask
	_target_height = collision_shape.shape.height


func _physics_process(delta: float) -> void:
	_handle_input()
	_update_crouch_height(delta)
	
	if noclip:
		_handle_noclip_movement()
	else:
		_handle_normal_movement(delta)
	
	move_and_slide()


func _handle_input() -> void:
	# === TOGGLE NOCLIP (V key) ===
	var v_pressed_now: bool = Input.is_physical_key_pressed(KEY_V)
	if v_pressed_now and not _v_pressed_last_frame:
		noclip = !noclip
		if noclip:
			velocity = Vector3.ZERO
			collision_layer = 0
			collision_mask = 0
		else:
			collision_layer = _original_collision_layer
			collision_mask = _original_collision_mask
	_v_pressed_last_frame = v_pressed_now

	# === TOGGLE CROUCH (C key) ===
	if Input.is_action_just_pressed("crouch"):
		crouching = !crouching
		_target_height = CROUCH_HEIGHT if crouching else STAND_HEIGHT


func _update_crouch_height(delta: float) -> void:
	if not collision_shape or not collision_shape.shape:
		return
	
	# Smoothly interpolate height
	var current_height: float = collision_shape.shape.height
	var new_height: float = move_toward(current_height, _target_height, CROUCH_LERP_SPEED * delta)
	collision_shape.shape.height = new_height
	
	# Update base speed
	speed = CROUCH_SPEED if crouching else BASE_SPEED


func _handle_noclip_movement() -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = direction.x * NOCLIP_SPEED
	velocity.z = direction.z * NOCLIP_SPEED
	
	# Vertical movement
	if Input.is_action_pressed("jump") or Input.is_physical_key_pressed(KEY_SPACE):
		velocity.y = NOCLIP_SPEED
	elif Input.is_physical_key_pressed(KEY_SHIFT):
		velocity.y = -NOCLIP_SPEED
	else:
		velocity.y = 0


func _handle_normal_movement(delta: float) -> void:
	# === GRAVITY ===
	if not is_on_floor():
		velocity += get_gravity() * delta

	# === JUMP (Different heights for crouch/stand) ===
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = CROUCH_JUMP_VELOCITY if crouching else STAND_JUMP_VELOCITY

	# === MOVEMENT INPUT ===
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# === GROUND SPEED (with sprint) ===
	var ground_speed: float = speed
	var can_sprint: bool = not crouching and Input.is_action_pressed("sprint") and direction.length() > 0.1
	
	if can_sprint:
		ground_speed *= SPRINT_MULTIPLIER

	# === AIR SPEED (preserves sprint momentum!) ===
	var air_speed: float = CROUCH_AIR_SPEED if crouching else AIR_SPEED
	
	# **KEY FIX**: Use ground sprint speed for air control if sprinting
	if not is_on_floor() and Input.is_action_pressed("sprint") and not crouching:
		air_speed = ground_speed  # Full sprint speed in air!

	var target_speed: float = ground_speed if is_on_floor() else air_speed

	# === APPLY MOVEMENT ===
	if direction.length() > 0.1:
		var target_velocity: Vector3 = direction * target_speed
		var accel: float = target_speed * 12.0 * delta
		velocity.x = move_toward(velocity.x, target_velocity.x, accel)
		velocity.z = move_toward(velocity.z, target_velocity.z, accel)
	else:
		var friction: float = speed * 8.0 * delta
		velocity.x = move_toward(velocity.x, 0, friction)
		velocity.z = move_toward(velocity.z, 0, friction)
