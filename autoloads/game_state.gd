extends Node

signal state_changed

var current_question:
    get:
        return current_question
    set(value):
        current_question = value
        state_changed.emit()
        
var avaliable_boosts: Dictionary = {
    "2x": 0,
    "arrow_right": 0,
    "bomb": 0,
    "brain": 0,
    "clock": 0,
    "double_arrow": 0,
}:
    get:
        return avaliable_boosts
    set(value):
        avaliable_boosts = value
        state_changed.emit()
        
var correct_answers: int = 0:
    get:
        return correct_answers
    set(value):
        correct_answers = value
        state_changed.emit()
        
var wrong_answers: int = 0:
    get:
        return wrong_answers
    set(value):
        wrong_answers = value
        state_changed.emit()

var starts_amount: int = 0:
    get:
        return starts_amount
    set(value):
        starts_amount = value
        state_changed.emit()

func reset_state():
    current_question = null
    avaliable_boosts = {
        "2x": 0,
        "arrow_right": 0,
        "bomb": 0,
        "brain": 0,
        "clock": 1,
        "double_arrow": 0,
    }
    correct_answers = 0
    wrong_answers = 0
    starts_amount = 0

func check_for_end():
    return wrong_answers >= 1 or correct_answers + wrong_answers == 10

func _ready():
    state_changed.emit()
