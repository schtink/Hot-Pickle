extends Node2D

onready var pickleSpeech = $"CanvasLayer/Pickle Speech"
onready var crustyPSpeech = $"CanvasLayer/Crusty P Speech"
onready var speechTime = $SpeechTime
onready var camera = $Camera2D

var currentSpeaker
var currentIndex = 0
var currentTotal

var dialogue = [
	{"pickle": "Oh no, Ol' Crusty P., the Lil' Gherkins have gone missing!"},
	{"pickle": "I just got released from The Big Pickle and came home to find them GONE!"},
	{"crustyp":"Cool story, Stephen J. Pickle. Yes, the Lil' Gherhkins have been TAKEN. Hee hee."},
	{"pickle": "Try not to sound so happy about it! Where ARE they?"},
	{"crustyp": "It was that blasted evil Burger Boss. He came to Pickle Village about a week ago..."},
	{"crustyp": "...kidnapped every Lil' Gherkin in sight. The screaming... the horror. Hee hee."},
	{"pickle": "But why? Why would he do something like that?"},
	{"crustyp": "You don't know? You're more naive than I thought."},
	{"pickle": "... ... ...?"},
	{"crustyp": "The Burger Boss is going to serve them in his burger restaurant..."},
	{"crustyp": "THE GREASE TRAP he calls it... Hee hee."},
	{"pickle": "OH MY GOD. Stop laughing, would you?"},
	{"crustyp": "The Grease Trap is just outside of Pickle Country..."},
	{"crustyp": "It'll be a long and dangerous journey... about 10 levels or so!"},
	{"pickle": "Wow, that's so specific... I MUST SAVE THEM!"},
	{"crustyp": "Whatever helps you sleep at night... Hee hee."},
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
	get_tree().change_scene("res://src/Level/World1/Greens.tscn")
