extends Control

onready var ResumeButton = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ResumeButton")
onready var QuitButton = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/QuitButton")
onready var MainMenuButton = get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Main Menu"
)
func _ready():
	ResumeButton.grab_focus()
	#connect("overlay_toggled", self, "_pause")

func _process(delta):
	#Steam.run_callbacks()
	pass

func _physics_process(delta):
	if(Input.is_action_just_pressed("Escape to Menu")) and Main.paused == false:
		_pause()
	
	if(Input.is_action_just_pressed("Escape to Menu")) and Main.paused == true and visible == true:
		_unpause()
	
	if (Main.paused):
		show()
	else:
		hide()
	
	if ResumeButton.is_hovered() == true:
		ResumeButton.grab_focus()
	elif MainMenuButton.is_hovered() == true:
		MainMenuButton.grab_focus()
	elif QuitButton.is_hovered() == true:
		QuitButton.grab_focus()

func _on_ResumeButton_pressed():
	_unpause()

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Main_Menu_pressed():
	get_tree().change_scene("res://src/UserInterface/Title Screen.tscn")
	_unpause()

func _pause():
	Main.paused = true
	get_tree().paused = true
	ResumeButton.grab_focus()

func _unpause():
	Main.paused = false
	get_tree().paused = false
