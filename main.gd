extends Node2D

@onready var slot = $SlotMachine
@onready var roll_button = $Roll
@onready var output = $output
@export var question_prefab: PackedScene

var current_question: Question = null

func _ready():
    assert(question_prefab, "Missing question_prefab")
    slot.stopped_all.connect(_on_slot_machine_stopped)
    roll_button.pressed.connect(_on_Roll_button_down)
    slot.stopped_all.connect(func(slots):
        print(slots)
        output.text = str(slots)
    )

    add_child(question_prefab.instantiate() as Question)
    current_question = question_prefab.instantiate() as Question
    add_child(current_question)
   


func _on_Roll_button_down():
    if roll_button.text == "Roll":
        slot.start()
        Globals.slot_start.emit()
        roll_button.text = "Stop"
        
        var new_question = question_prefab.instantiate() as Question
        add_child(new_question)
        #new_question.z_index = -2
        
        current_question.move_to_front()
        current_question.flip_page()
        await current_question.flip_finished
        current_question.queue_free()
        current_question = new_question

        # slot.start()
        # Globals.slot_start.emit()
        # roll_button.text = "Stop"

func _on_slot_machine_stopped(slots):
    roll_button.text = "Roll"
