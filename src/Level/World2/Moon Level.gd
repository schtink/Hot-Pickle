extends Node2D

export var levelID = 7

func _ready():
	$Player/Player/Camera2D.limit_bottom = 64
	$Player/Player/Camera2D.limit_top = -1400
	$Player/Player/Camera2D.limit_left = -64
	$Player/Player/Camera2D.limit_right = 18216
	Main.current_level = levelID
	Main.target_stage = get_filename()

func _process(delta):
	if Main.playerInert == true:
		$AudioFade.play("AudioFade")
