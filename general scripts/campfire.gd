extends Node3D

@export var on = false
@export var light_color: Color

func _ready() -> void:
	$Light.light_color = light_color
	$Light.visible = on
	$flames.visible = on
	$smoke.visible = on

func toggle_light():
	on = !on
	$Light.visible = on
	$flames.visible = on
	$smoke.visible = on
