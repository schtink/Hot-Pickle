extends CanvasLayer
onready var music = get_owner().get_node("AudioStreamPlayer")

func _process(delta):
	if Main.dizzy == false && $DizzyTimer.is_stopped():
		$DizzyEffect.visible = false
		music.pitch_scale = 1
	if Main.dizzy == true:
		$DizzyEffect.visible = true
		$DizzyTimer.start()
		Main.dizzy = false
		music.pitch_scale = 0.5
