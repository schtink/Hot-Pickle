extends Node2D

export var levelID = 1

func _ready():
	$Player/Player/Camera2D.limit_bottom = 768
	$Player/Player/Camera2D.limit_top = -1248
	$Player/Player/Camera2D.limit_left = 0
	$Player/Player/Camera2D.limit_right = 11710
	Main.current_level = levelID
	Main.target_stage = get_filename()


func _process(delta):
	if Main.playerInert == true:
		$AudioFade.play("AudioFade")
