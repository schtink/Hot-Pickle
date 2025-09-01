extends Area2D

export var level_checkpoint = "none"

func _ready():
	if Main.level_checkpoint == level_checkpoint:
		$AnimatedSprite.play("pickle")
	elif Main.level_checkpoint != level_checkpoint:
		$AnimatedSprite.play("burger")

func _physics_process(delta):
	pass
		
func _on_Checkpoint_body_entered(body):
	if Main.level_checkpoint != level_checkpoint:
		if body.is_in_group("player"):
			Main.level_checkpoint = level_checkpoint
			Main._save_player_data()
			$AnimatedSprite.play("flip")
			AudioManager.play("res://assets/audio/effects/yeah.wav")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "flip":
		$AnimatedSprite.play("pickle")
