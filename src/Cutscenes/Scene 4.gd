extends Node2D

onready var pickleSpeech = $"CanvasLayer/Pickle Speech"
onready var crustyPSpeech = $"CanvasLayer/Crusty P Speech"
onready var speechTime = $SpeechTime
onready var camera = $Camera2D

var currentSpeaker
var currentIndex = 0
var currentTotal

var dialogue = [
	{"pickle": "Well, Ol' Crusty P., the evil Burger Boss is defeated."},
	{"crustyp":"You've done it, Stephen. You've saved all the Lil' Gherkins."},
	{"crustyp": "What will you do now? Go to Disney World? Hee hee."},
	{"pickle": "No, I wasn't paid to say that this time."},
	{"pickle": "I guess I'll just try to settle down with my Lil' Gherkins..."},
	{"pickle": "...move to the country... Live off the land. Stay out of trouble..."},
	{"crustyp": "How incredibly boring. Hee hee."},
	{"crustyp": "Well, at least you and those tasty Gherkins are safe..."},
	{"pickle": "What, WHAT? You didn't! You couldn't! You didn't really...?"},
	{"crustyp": "Oh, look at the time. Got to be going now. Hee hee."},
	{"pickle": "What the dill, Ol' Crusty P!? I knew your laugh was suspicious!"},
	{"crustyp": "Hee hee."},
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
	get_tree().change_scene("res://src/UserInterface/Credits.tscn")
