extends Control

onready var back = get_node("MarginContainer/VBoxContainer/HBoxContainer/Col 1/Back")

func _ready():
	AudioManager.play("res://assets/audio/effects/bell.wav")
	back.grab_focus()

func _physics_process(delta):
	if back.is_hovered() == true:
		back.grab_focus()

func _on_FadeIn_fadein_finished():
	get_tree().change_scene(Main.target_stage)


func _on_Back_pressed():
	startScene("res://src/UserInterface/Title Screen.tscn")


func _on_Scene_1_pressed():
	startScene("res://src/Cutscenes/Scene 1.tscn")


func _on_End_Credits_pressed():
	startScene("res://src/UserInterface/Credits.tscn")


func _on_Greens_1_pressed():
	startScene("res://src/Level/World1/Greens.tscn")


func _on_Greens_2_pressed():
	startScene("res://src/Level/World1/Greens2.tscn")


func _on_Ocean_pressed():
	startScene("res://src/Level/World1/Water Level.tscn")


func _on_Desert_of_Pain_pressed():
	startScene("res://src/Level/World1/Desert.tscn")


func _on_Space_pressed():
	startScene("res://src/Level/World2/Moon Level.tscn")


func _on_The_Fridge_pressed():
	startScene("res://src/Level/World2/Fridge.tscn")


func _on_Mines_pressed():
	startScene("res://src/Level/World2/Mines.tscn")


func _on_Scene_2_pressed():
	startScene("res://src/Cutscenes/Scene 2.tscn")


func _on_Mines2_pressed():
	startScene("res://src/Level/World2/Mines2.tscn")

func _on_Scene_3_pressed():
	startScene("res://src/Cutscenes/Scene 3.tscn")

func _on_Grease_Trap_pressed():
	startScene("res://src/Level/World2/Grease Trap.tscn")


func _on_Kitchen_pressed():
	startScene("res://src/Level/World2/Grease Trap2.tscn")


func startScene(newScene):
	Main.target_stage = newScene
	$FadeIn.show()
	$FadeIn.fade_in()
