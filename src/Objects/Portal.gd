extends Area2D

export(String, FILE, "*.tscn") var target_stage

func _process(delta):
	rotate(0.01)

func _on_Donut_body_shape_entered(body_id, body, body_shape, local_shape):
	if "Player" in body.name:
		Main.playerInert = true
		Main.level_checkpoint = "none"
		Main._save_player_data()
		Main.target_stage = target_stage
		Main.startSceneChange = true
