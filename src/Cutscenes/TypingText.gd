extends RichTextLabel

var lapsed = 0

func _ready():
	lapsed = 0

func _physics_process(delta):
	lapsed += delta
	visible_characters = lapsed/0.05
	if self.percent_visible >= 100:
		self.visible_characters = 0
