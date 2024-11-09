extends Node2D

export var levelID = 0
onready var _pause_menu = get_node("InterfaceLayer/PauseScreen")

func _ready():
	$Player/Player/Camera2D.limit_bottom = 768
	$Player/Player/Camera2D.limit_top = -1800
	$Player/Player/Camera2D.limit_left = 0
	$Player/Player/Camera2D.limit_right = 9216
	Main.current_level = levelID
	Main.target_stage = get_filename()


func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.visible = true
		else:
			_pause_menu.visible = false
		get_tree().set_input_as_handled()
