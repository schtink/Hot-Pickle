extends Area2D

export(String, FILE, "*.tscn") var target_stage

func _ready():
	pass


func _on_Level_Complete_body_entered(body):
	if "Player" in body.name:
		Main.target_stage = target_stage
		Main._save_player_data()
		get_tree().change_scene("res://src/UserInterface/Remaining Lives.tscn")
