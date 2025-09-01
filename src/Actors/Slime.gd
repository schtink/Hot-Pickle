extends KinematicBody2D

signal player_hit
var is_dead = false
var is_dripping = false

onready var dripSprite = $Drip
onready var dripCollision = $DripCollision
onready var dripOccluder = $LightOccluder2D2
onready var slimeAnimation = $SlimeAnimation
onready var dripTimer = $DripTimer

func _ready():
	dripSprite.visible = false
	dripCollision.visible = false
	dripCollision.disabled = true
	dripOccluder.visible = false

func _physics_process(delta):
	_collide_with_player()
	if is_dripping == false:
		dripTimer.start()
		is_dripping = true

func _drip():
	slimeAnimation.play("Drip")
	dripSprite.visible = true
	dripCollision.visible = true
	dripCollision.disabled = false
	dripOccluder.visible = true

func _dead(damage):
	pass
	
func _collide_with_player():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				get_slide_collision(i).collider._dead("slime")


func _on_SlimeAnimation_animation_finished(anim_name):
	dripSprite.visible = false
	dripCollision.visible = false
	dripCollision.disabled = true
	dripOccluder.visible = false


func _on_DripTimer_timeout():
	_drip()
	is_dripping = false
