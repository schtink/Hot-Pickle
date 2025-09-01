extends Node2D

export var levelID = 6

func _ready():
	$Player/Player/Camera2D.limit_bottom = 832
	$Player/Player/Camera2D.limit_top = -1800
	$Player/Player/Camera2D.limit_left = 0
	$Player/Player/Camera2D.limit_right = 19432
	Main.current_level = levelID
	Main.target_stage = get_filename()

func _process(delta):
	if Main.playerInert == true:
		$AudioFade.play("AudioFade")
