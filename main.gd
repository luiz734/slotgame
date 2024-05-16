extends Node2D

@onready var slot = $SlotMachine
@onready var roll_button = $Roll
@onready var output = $output
@export var question_prefab: PackedScene

var current_question: Question = null

func _ready():
    assert(question_prefab, "Missing question_prefab")
    assert(roll_button, "Missing roll_button")
    assert(output, "Missing output")
    slot.stopped_all.connect(_on_slot_machine_stopped)
    roll_button.pressed.connect(_on_Roll_button_down)
    slot.stopped_all.connect(func(slots):
        print(slots)
        output.text = str(slots)
    )
    
    current_question = create_question()
    add_child(current_question)

func create_question() -> Question:
    var question = question_prefab.instantiate() as Question
    question.position += Vector2(0, 0)
    return question

func _on_Roll_button_down():
    current_question.move_to_front()
    current_question.flip_page()
    await current_question.flip_finished
    var new_question = create_question()
    add_child(new_question)
    
    current_question.queue_free()
    current_question = new_question

func _on_slot_machine_stopped(slots):
    # roll_button.text = "Roll"
    pass
