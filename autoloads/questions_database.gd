extends Node

@export var questions: Array[QuestionData] = []

var last_question: QuestionData = null

#  -------------- W A R N I N G   --------------
# Uncomenting the section bellow will overwrite all the content of question/questions
#var questions_reader = preload("res://question/question_loader.gd")
#@onready var questions_matrix = questions_reader.new().load_text_file("res://question/question.txt")
#  ---------------------------------------------

func _ready():
    for i in range(1, 31):
        questions.push_back(load("res://question/questions/q" + str(i) + ".tres"))
    assert(len(questions) > 0, "Can't load any question")
    shuffle_question()

func get_last_question() -> QuestionData:
    return last_question
 
func shuffle_question():
    last_question = questions.pick_random()
    GameState.current_question = last_question
