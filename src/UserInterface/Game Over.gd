extends Node2D

onready var timer = get_node("Timer")

func _ready():
	AudioManager.play("res://assets/audio/effects/Dead_Music.wav")
	timer.start()
	pass # Replace with function body.

func _process(delta):
	if timer.is_stopped():
		get_tree().change_scene("res://src/UserInterface/Title Screen.tscn")
