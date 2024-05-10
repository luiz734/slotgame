extends Resource
class_name QuestionData

@export var question: String:
    get:
        return question
    set(v):
        question = v
        
@export var altertative_1: String = "none":
    get:
        return altertative_1
    set(v):
        altertative_1 = v
@export var altertative_2: String = "none":
    get:
        return altertative_2
    set(v):
        altertative_2 = v
