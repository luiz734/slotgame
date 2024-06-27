extends Node

@export var questions: Array[QuestionData] = []
var _avaliable_questions: Array = []

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
    
    Globals.game_start.connect(func():
        _avaliable_questions = questions.map(func(x): return x)
        _avaliable_questions.shuffle()
    )
    _avaliable_questions = questions.map(func(x): return x)
    _avaliable_questions.shuffle()
    shuffle_question()

func get_last_question() -> QuestionData:
    return last_question
 
func shuffle_question():
    last_question = _avaliable_questions.pop_back()
    GameState.current_question = last_question
