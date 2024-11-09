extends Control

onready var ResumeButton = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ResumeButton")

func _ready():
	ResumeButton.grab_focus()

func _physics_process(delta):
	if ResumeButton.is_hovered() == true:
		ResumeButton.grab_focus()

func _on_ResumeButton_pressed():
	print ("This?")
	#get_tree().paused = false
	#visible = false
