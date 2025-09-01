extends HSlider

export var audio_bus_name := "Master"

onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	value = db2linear(AudioServer.get_bus_volume_db(_bus))

func _on_MusicSlider_value_changed(value):
	Main.music_volume = value
	AudioServer.set_bus_volume_db(_bus, linear2db(value))


func _on_SFXSlider_value_changed(value):
	Main.sfx_volume = value
	AudioManager.play("res://assets/audio/effects/bell.wav")
	AudioServer.set_bus_volume_db(_bus, linear2db(value))
