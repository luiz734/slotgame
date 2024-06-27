extends VBoxContainer
class_name OptionsGroup

@onready var _visible_position: Vector2 = position
@onready var _hidden_position: Vector2 = position + Vector2(800.0, 0.0)

signal correct_answer(button)
signal wrong_answer(button)

func change_options_entries(options_str, correct_index):
    var options = get_children()
    for i in range(len(options)):
        options[i].is_correct = false
        options[i].set_label(options_str[i])
        if i == correct_index:
            options[i].is_correct = true
            print(correct_index)   

func _ready():
    position = _hidden_position
    for option in get_children():
        option.clicked.connect(func(data: Dictionary):
            if data["correct"]:
                correct_answer.emit(data["button"])
            else:
                wrong_answer.emit(data["button"])
        )
    Globals.boost_used.connect(func(id):
        if id != "bomb":
            return
        var options = get_children()
        var count = 0
        while count < 2:
            var rand_index = randi() % len(options)
            var random_wrong = options[rand_index]
            options.remove_at(rand_index)
            if random_wrong.is_correct:
                continue
            random_wrong.hide_all()
            count += 1
    )
func show_correct_answer():
    for c in get_children():
        if c.is_correct:
            await c.play_correct_answer_animation()
            return
            
func unhide_all_options():
    for c in get_children():
        c.unhide_all()

func play_appear_animation():
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(self, "position", _visible_position, 1.0)
    await tween.finished

func play_hidde_animation():
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(self, "position", _hidden_position, 1.4)
    await tween.finished
