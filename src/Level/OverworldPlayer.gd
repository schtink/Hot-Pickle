extends AnimatedSprite

const SPEED = 500

func _physics_process(delta):
	get_parent().set_offset(get_parent().get_offset() + (SPEED*delta))
