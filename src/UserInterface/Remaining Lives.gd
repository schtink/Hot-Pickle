extends Node2D

onready var timer = get_node("Timer")
onready var lives_label = get_node("Control/HBoxContainer/VBoxContainer/Remaining Lives")

func _ready():
	#reset player stats
	if Main.reset_player_stats == true:
		Main._reset_player_stats()

	var new_lives_label = Main.player_lives
	new_lives_label = str("x ", new_lives_label)
	lives_label.text = new_lives_label
	timer.start()

func _process(delta):
	if timer.is_stopped():
		print(Main.target_stage)
		get_tree().change_scene(Main.target_stage)
