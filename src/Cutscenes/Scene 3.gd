extends Node2D

onready var pickleSpeech = $"CanvasLayer/Pickle Speech"
onready var crustyPSpeech = $"CanvasLayer/Crusty P Speech"
onready var speechTime = $SpeechTime
onready var camera = $Camera2D

var currentSpeaker
var currentIndex = 0
var currentTotal

var dialogue = [
	{"pickle": "What just happened to me, Ol' Crusty P?"},
	{"crustyp":"Stephen, you just went through a bona-fide space portal. Hee hee."},
	{"pickle": "What?!?! I'll die in space. You gotta help me."},
	{"crustyp": "No can do, boy. You're already halfway there."},
	{"pickle": "If I just went through a portal, then what am I doing here?"},
	{"crustyp": "All my conversations take place here. Hee hee."},
	{"crustyp": "Here, take this space helmet. I don't need it anymore."},
	{"pickle": "Wait, why do you have a space helmet? Nevermind...forget I asked..."},
	{"crustyp": "Just find the second portal to get back. It'll take you straight to The Grease Trap."},
	{"pickle": "This is not the road I expected to take out of Pickle Country..."},
	{"crustyp": "Where you're going, you don't need roads. Hee hee."},
	{"pickle": "I really wish you would stop laughing..."},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	advanceDialogue()

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			fadeScene()

func _process(delta):
	camera.position.x +=0.4
	if currentSpeaker == "pickle" && pickleSpeech.lapsed >= currentTotal:
		advanceDialogue()
	if currentSpeaker == "crustyp" && crustyPSpeech.lapsed >= currentTotal:
		advanceDialogue()

func advanceDialogue():
	if currentIndex < dialogue.size():
		var keys = dialogue[currentIndex].keys()
		var values = dialogue[currentIndex].values()
		var key = keys[0]
		var value = values[0]
		
		crustyPSpeech.text = " "
		pickleSpeech.text = " "
		
		currentTotal = key.length() - 1
		
		if key == "pickle":
			currentSpeaker = "pickle"
			pickleSpeech.text = value
			pickleSpeech.lapsed = 0
			pickleSpeech.percent_visible = 0

		elif key == "crustyp":
			currentSpeaker = "crustyp"
			crustyPSpeech.text = value
			crustyPSpeech.lapsed = 0
			crustyPSpeech.percent_visible = 0

		currentIndex += 1
#		speechTime.start()
	else:
		fadeScene()


func fadeScene():
	$AudioFade.play("AudioFade")
	$CanvasLayer/FadeIn.show()
	$CanvasLayer/FadeIn.fade_in()

func _on_SpeechTime_timeout():
	advanceDialogue()


func _on_FadeIn_fadein_finished():
	get_tree().change_scene("res://src/Level/World2/Moon Level.tscn")
