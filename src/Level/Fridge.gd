extends Node2D

export var levelID = 0

func _ready():
	$Player/Player/Camera2D.limit_bottom = 64
	$Player/Player/Camera2D.limit_top = -8000
	$Player/Player/Camera2D.limit_left = 0
	$Player/Player/Camera2D.limit_right = 1920
	Main.current_level = levelID
	Main.target_stage = get_filename()
