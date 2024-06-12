extends Node2D

#@onready var slot = $SlotMachine
@onready var roll_button = $Roll
@onready var output = $output
@export var question_prefab: PackedScene

@onready var options: Array[QuestionOption] = []
var current_question: Question = null
@onready var options_container: OptionsGroup = get_node("Background/Options")
@onready var answer_timer: AnswerTimer = $AnswerTimer

@onready var transition = %Transition
@onready var history = %History

func on_correct_answer(button: QuestionOption):
    answer_timer.stop()
    await button.play_correct_answer_animation()
    await history.play_next_ball(true)
    
    GameState.correct_answers += 1
    go_to_next_question()
    if GameState.check_for_end():
        get_tree().quit()

func on_wrong_answer(button: QuestionOption):
    answer_timer.stop()
    await button.play_wrong_answer_animation()
    await history.play_next_ball(false)

    GameState.wrong_answers += 1
    go_to_next_question()
    if GameState.check_for_end():
        get_tree().quit()

func on_answer_timeout():
    GameState.wrong_answers += 1
    go_to_next_question()

func _ready():
    assert(question_prefab, "Missing question_prefab")
    assert(roll_button, "Missing roll_button")
    assert(output, "Missing output")
    assert(options_container, "Missing options_container reference")
    assert(answer_timer, "Missing answer_timer reference")
    assert(transition, "Missing transition reference")
    
    transition.start_reversed()
    await transition.finished
    
    answer_timer.timeout.connect(on_answer_timeout)
   
    options_container.correct_answer.connect(on_correct_answer)
    options_container.wrong_answer.connect(on_wrong_answer)
    
    for c in options_container.get_children():
        options.push_back(c as QuestionOption)
    assert(options and len(options) == 4, "Can't load options")
    
    Globals.slot_stopped.connect(_on_slot_machine_stopped)
    roll_button.pressed.connect(go_to_next_question)
    Globals.slot_stopped.connect(func(res):
        output.text = str(res)
    )
    
    current_question = create_question()
    var current_q: QuestionData = QuestionsDatabase.get_last_question()
    
    options_container.change_options_entries(current_q.options, current_q.correct) 
    add_child(current_question)

    await get_tree().create_timer(0.4).timeout
    await options_container.play_appear_animation()
    
    answer_timer.reset_timer()
    # await get_tree().create_timer(0.4).timeout
    # options_container.play_hidde_animation()

func create_question() -> Question:
    var question = question_prefab.instantiate() as Question
    question.position += Vector2(0, 100)
    return question

func go_to_next_question():
    QuestionsDatabase.shuffle_question()
    
    current_question.move_to_front()
    current_question.flip_page()
    await get_tree().create_timer(0.6).timeout
    options_container.play_hidde_animation()
    await current_question.flip_finished
    
    var new_question = create_question()
    add_child(new_question)

    #await get_tree().create_timer(0.4).timeout
    await options_container.play_appear_animation()
    
    current_question.queue_free()
    current_question = new_question
   
    var current_q: QuestionData = QuestionsDatabase.get_last_question()
    options_container.change_options_entries(current_q.options, current_q.correct) 
    
    answer_timer.reset_timer()
    

func _on_slot_machine_stopped(slots):
    print("foo")
