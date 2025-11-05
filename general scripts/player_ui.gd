extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$pause_menu.visible = false
	$Settings.visible = false
	$Controls.visible = false

func resume_game():
	get_tree().paused = false
	$pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func open_settings():
	$Settings.visible = true
	$pause_menu.visible = false

func close_settings():
	$pause_menu.visible = true
	$Settings.visible = false
	$Controls.visible = false

func open_controls():
	$pause_menu.visible = false
	$Controls.visible = true
func quit_game():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !$Settings.visible:
		$pause_menu.visible = !$pause_menu.visible
		get_tree().paused = $pause_menu.visible
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if !get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("pause") and ($Settings.visible or $Controls.visible):
		$pause_menu.visible = true
		$Settings.visible = false
		$Controls.visible = false
