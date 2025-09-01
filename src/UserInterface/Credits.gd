extends Node2D

onready var song = $"Just a Pickle"
onready var camera = $Camera2D


const section_time := 2.0
const line_time := 0.8
const base_speed := 60
const speed_up_multiplier := 10.0
const title_color := Color.green

var scroll_speed := base_speed
var speed_up := false

onready var line := $CanvasLayer/CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"Hot Pickle!"
	],[
		" "
	],[
		" "
	],[
		" "
	],[
		" "
	],[
		"Written and Directed by",
		"Benjamin Stark"
	],[
		"Voices",
		"Stephen J. Pickle    Benjamin Stark",
		"Big Burger Boss    Mercury Stark",
		"Additional Voices    Benjamin Stark"
	],[
		"Programming",
		"Benjamin Stark"
	],[
		"Art & Backgrounds",
		"Benjamin Stark"
	],[
		"Original Score",
		"Written and Performed by",
		"Benjamin Stark"
	],[
		"Music",
		"\"I Am Just A Pickle\"",
		"Written and Performed by",
		"Chris Alarie",
		" ",
		"\"Pickle Beats\"",
		"Written by",
		"Andy Stark",
		"Performed by",
		"Emil G.",
	],[
		"Sound Effects",
		"Benjamin Stark"
	],[
		"Testers",
		"Kai Kupper",
		"Jose Martinez",
		"Benjamin Hammer",
		"Giovanni Rivas",
		"Mercury Stark"
	],[
		"Developed with Godot Engine"
	],[
		"Special thanks",
		"Bobby Stark",
		"Mercury Stark",
		"Andy Stark",
		"Myrna Stark",
		"Chris Alarie",
		"Tom Brizendine",
		"Ethan Wilde",
		"Santa Rosa Junior College"
	],[
		" "
	],[
		" "
	],[
		" "
	],[
		" ",
		"(C) Copyright 2021 Benjamin Stark"
	],[
		" "
	],[
		" "
	],[
		" "
	],[
		" ",
		"You're still here?"
	],[
		" "
	],[
		" "
	],[
		" "
	],[
		" ",
		"It's over"
	],[
		" "
	],[
		" "
	],[
		" "
	],[
		" ",
		"Turn off your computer"
	],[
		" "
	],[
		" "
	],[
		" "
	],[
		" ",
		"Go"
	]
]

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			$CanvasLayer/FadeIn.show()
			$CanvasLayer/FadeIn.fade_in()

func _ready():
	song.play()

func _process(delta):
	
	camera.position.y +=0.4

	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		# NOTE: This is called when the credits finish
		# - Hook up your code to return to the relevant scene here, eg...
		#get_tree().change_scene("res://scenes/MainMenu.tscn")


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()

	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CanvasLayer/CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false

func _returnToMenu():
	get_tree().change_scene("res://src/UserInterface/Title Screen.tscn")


func _on_Just_a_Pickle_finished():
	$CanvasLayer/FadeIn.show()
	$CanvasLayer/FadeIn.fade_in()
	
func _on_FadeIn_fadein_finished():
	_returnToMenu()
