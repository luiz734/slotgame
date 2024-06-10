extends VBoxContainer
class_name OptionsGroup

@onready var _visible_position: Vector2 = position
@onready var _hidden_position: Vector2 = position + Vector2(800.0, 0.0)

signal correct_answer
signal wrong_answer

func change_options_entries(options_str, correct_index):
    var options = get_children()
    for i in range(len(options)):
        options[i].set_label(options_str[i])
        if i == correct_index:
            options[i].is_correct = true   

func _ready():
    position = _hidden_position
    for option in get_children():
        option.clicked.connect(func(data: Dictionary):
            if data["correct"]:
                correct_answer.emit()
            else:
                wrong_answer.emit()
        )

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
