extends CanvasLayer

var player_head
var environment: Environment

func _ready() -> void:
	if get_tree().current_scene.name == "World":
		player_head = get_tree().current_scene.get_node("player/head")
		environment = get_tree().current_scene.get_node("WorldEnvironment").environment

func set_aa(index):
	if index == 0:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	elif index == 1:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		get_viewport().use_taa = false
	elif index == 2:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = true
	elif index == 3:
		get_viewport().msaa_3d = Viewport.MSAA_2X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	elif index == 4:
		get_viewport().msaa_3d = Viewport.MSAA_4X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false
	elif index == 5:
		get_viewport().msaa_3d = Viewport.MSAA_8X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		get_viewport().use_taa = false

func set_fps_cap(index):
	if index == 0:
		Engine.max_fps = 30
	elif index == 1:
		Engine.max_fps = 60
	elif index == 2:
		Engine.max_fps = 0

func set_vsync(toggle):
	if !toggle:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	if toggle:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func toggle_glow(toggle):
	if environment != null:
		environment.glow_enabled = toggle

func toggle_vol_fog(toggle):
	if environment != null:
		environment.volumetric_fog_enabled = toggle

func scale3d(value):
	get_viewport().scaling_3d_scale = value

func set_master_vol(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func set_music_vol(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

func set_sfx_vol(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func set_look_speed(value):
	if player_head != null:
		player_head.sensitivity = value

func set_window_mode(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func set_shadow(index):
	if index == 0:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_HARD)
	elif index == 1:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
	elif index == 2:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
	elif index == 3:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
	elif index == 4:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
	elif index == 5:
		RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
		RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
