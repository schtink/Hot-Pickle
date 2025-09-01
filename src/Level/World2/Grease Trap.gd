extends Node2D

export var levelID = 9

func _ready():
	$Player/Player/Camera2D.limit_bottom = 384
	$Player/Player/Camera2D.limit_top = -384
	$Player/Player/Camera2D.limit_left = 0
	$Player/Player/Camera2D.limit_right = 11710
	Main.current_level = levelID
	Main.target_stage = get_filename()
	Main.audiotriggered = false


func _process(delta):
	if Main.playerInert == true:
		$AudioFade.play("AudioFade")
