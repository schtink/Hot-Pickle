extends Node2D

onready var pickleSpeech = $"CanvasLayer/Pickle Speech"
onready var crustyPSpeech = $"CanvasLayer/Crusty P Speech"
onready var speechTime = $SpeechTime
onready var camera = $Camera2D

var currentSpeaker
var currentIndex = 0
var currentTotal

var dialogue = [
	{"sporker":"You have defeated me, Stephen J. Pickle..."},
	{"sporker":"I will never deliver sustenance into the great food hole ever again..."},
	{"pickle": "Dont' be down Sporker... We can still be friends."},
	{"sporker": "Really? ... You mean it? ... You want to be my friend? Even after..."},
	{"pickle": "Everyone in Pickle Country is my friend."},
	{"pickle": "Let's get you cleaned up."},
	{"sporker": "I don't even know how to thank you..."},
	{"pickle": "Just have my back once in a while."},
	{"sporker": "I will! I will be there for you when you need me!"},
	{"sporker": "Gosh... why did I work for that evil Burger Boss for so long?"},
	{"sporker": "He was never kind to me... Never once gave me a raise..."},
	{"sporker": "I battle his foes just under 40 hours a week..."},
	{"sporker": "That way he doesn't have to give me benefits..."},
	{"sporker": "...work conditions are hostile and unsanitary..."},
	{"pickle": "I really have to be going soon..."},
	{"sporker": "We don't even have a soda machine in the break room anymore..."},
	{"pickle": "I'm just gonna start walking this way, toward the exit..."},
	{"sporker": "...and can you believe Bob got a Christmas bonus and I didn't?"},
	{"sporker": "All Bob can do is make french fries. What's so special about that?"}
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
	if currentSpeaker == "sporker" && crustyPSpeech.lapsed >= currentTotal:
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

		elif key == "sporker":
			currentSpeaker = "sporker"
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
	get_tree().change_scene("res://src/Level/World2/Mines.tscn")
