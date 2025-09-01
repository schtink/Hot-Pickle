extends Control

onready var back_button = get_node("MarginContainer/VBoxContainer/HBoxContainer/Left/BACK")

func _ready():
	AudioManager.play("res://assets/audio/effects/bell.wav")
	back_button.grab_focus()

func _physics_process(delta):
	if back_button.is_hovered() == true:
		back_button.grab_focus()

func _on_BACK_pressed():
	get_tree().change_scene("res://src/UserInterface/Options.tscn")
