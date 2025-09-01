extends CanvasLayer

onready var score_label = get_node("Control/MarginContainer/VBoxContainer/HBoxContainer/Score")
onready var lives_label = get_node("Control/MarginContainer/VBoxContainer2/Lives")
onready var item = get_node("Control/MarginContainer/VBoxContainer/Item/Item")
onready var health1 = get_node("Control/MarginContainer/VBoxContainer/Health/Health1")
onready var health2 = get_node("Control/MarginContainer/VBoxContainer/Health/Health2")
onready var health3 = get_node("Control/MarginContainer/VBoxContainer/Health/Health3")
onready var health4 = get_node("Control/MarginContainer/VBoxContainer/Health/Health4")
onready var fpslabel = get_node("Control/MarginContainer/VBoxContainer2/FPS")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Main.playerInert = false
	Main.audiotriggered = false

	_update_score()
	_update_lives()
	_update_item()

func _update_lives():
	var livesText : = String(Main.player_lives)
	#livesText = lives_label.pad_zeros(5)
	lives_label.clear()
	lives_label.add_text(livesText)
	print(livesText)

func _update_score():
	var scoreText : = String(Main.player_score)
	scoreText = scoreText.pad_zeros(5)
	score_label.clear()
	score_label.add_text(scoreText)

func _update_item():
	if Main.power_up == 0:
		item.play("default")
	elif Main.power_up == 1:
		item.play("pepper")
	elif Main.power_up == 3:
		item.play("corn")

func _update_health():
	if Main.player_health == 4:
		health4.visible = true
		health3.visible = true
		health2.visible = true
		health1.visible = true
	elif Main.player_health == 3:
		health4.visible = false
		health3.visible = true
		health2.visible = true
		health1.visible = true
	elif Main.player_health == 2:
		health4.visible = false
		health3.visible = false
		health2.visible = true
		health1.visible = true
	elif Main.player_health == 1:
		health4.visible = false
		health3.visible = false
		health2.visible = false
		health1.visible = true
	elif Main.player_health == 0:
		health4.visible = false
		health3.visible = false
		health2.visible = false
		health1.visible = false

func _on_Pickle_Jar_jar_collected():
	Main.player_score += 1
	if Main.player_score % 100 == 0:
		Main.player_lives += 1
		AudioManager.play("res://assets/audio/effects/yeah.wav")
		_update_lives()
	_update_score()


func _physics_process(delta):
	_update_lives()
	_update_item()
	_update_health()
	
	if (Main.startSceneChange == true):
		Main.startSceneChange = false
		$FadeIn.show()
		$FadeIn.fade_in()

	if Main.show_fps == true:
		fpslabel.visible = true
		fpslabel.text = str("FPS ", Performance.get_monitor(Performance.TIME_FPS))
	else:
		fpslabel.visible = false



func _on_FadeIn_fadein_finished():
	get_tree().change_scene("res://src/UserInterface/Remaining Lives.tscn")
