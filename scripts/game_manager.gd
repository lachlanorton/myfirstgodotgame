extends Node
@onready var score_label: Label = $ScoreLabel

var score = 0

func add_point():
	score += 1
	# print(score)
	score_label.text = "You have collected " + str(score) + " coins!"
