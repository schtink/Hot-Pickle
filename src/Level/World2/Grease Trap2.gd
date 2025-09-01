extends Node2D

export var levelID = 10

func _ready():
	$Player/Player/Camera2D.limit_bottom = 384
	$Player/Player/Camera2D.limit_top = -448
	$Player/Player/Camera2D.limit_left = 0
	$Player/Player/Camera2D.limit_right = 18180
	Main.current_level = levelID
	Main.target_stage = get_filename()

func _process(delta):
	if Main.playerInert == true:
		$AudioFade.play("AudioFade")
