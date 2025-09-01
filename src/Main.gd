extends Node2D

#GLOBALS
const UNIT_SIZE = 64

const SAVE_DIR = "user://saves/"
const LEVEL_ONE = "res://src/Cutscenes/Scene 1.tscn"

var save_path = SAVE_DIR + "save.dat"

## global player variables ##
var player_score = 0
var player_lives = 5
var current_level = 1
var player_health = 4
var level_checkpoint = "none"
var start_point = Vector2(0,0)
var power_up = 0
var target_stage = LEVEL_ONE
var beat_game = false

#temporary variables
var reset_player_stats = false
var dizzy = false
var audiotriggered = false
var playerInert = false
var paused = false

# settings
var show_fps = false
var music_volume = 1
var sfx_volume = 0.75
var startSceneChange = false

func _ready():
	_refresh_player_data()

# Reset player stats
func _reset_player_stats():
	power_up = 0
	player_health = 4
	reset_player_stats = false
	_save_player_data()

# Reset all player data to default values
func _reset_to_defaults():
	print ("Reset to defaults called")
	player_score = 0
	player_lives = 5
	current_level = 1
	player_health = 4
	level_checkpoint = "none"
	start_point = Vector2(0,0)
	power_up = 0
	target_stage = LEVEL_ONE
	audiotriggered = false
	beat_game = false
	_save_player_data()

func _refresh_player_data():
	var player_data = Main._load()
	if player_data:
		current_level = player_data.get("current_level")
		player_lives = player_data.get("player_lives")
		player_score = player_data.get("player_score")
		power_up = player_data.get("power_up")
		level_checkpoint = player_data.get("level_checkpoint")
		target_stage = player_data.get("target_stage")
		show_fps = player_data.get("show_fps")
		music_volume = player_data.get("music_volume")
		sfx_volume = player_data.get("sfx_volume")
		
		#reset bus volumes from player data
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_volume))
	else:
		_save_player_data()

func _save_player_data():
	var data = {
		"current_level" : current_level,
		"player_lives" : player_lives,
		"player_score" : player_score,
		"power_up" : power_up,
		"level_checkpoint" : level_checkpoint,
		"target_stage" : target_stage,
		"show_fps" : show_fps,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume,
		"beat_game" : beat_game,
	}
	_save(data)

func _save(data):
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
#	var error = file.open(save_path, File.WRITE)
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "P@paB3ar6969")
	if error == OK:
		file.store_var(data)
		file.close()

func _load():
	var file = File.new()
	if file.file_exists(save_path):
#		var error = file.open(save_path, File.READ)
		var error = file.open_encrypted_with_pass(save_path, File.READ, "P@paB3ar6969")
		if error == OK:
			var player_data = file.get_var()
			file.close()
			return player_data

func _delete():
	var dir = Directory.new()
	dir.remove(SAVE_DIR)
