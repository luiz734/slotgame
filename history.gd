extends HBoxContainer
class_name History

var balls: Array[HistoryBall] = []
var current_index = 0

func _ready():
    assert(get_child_count() == 10, "Must have 10 history balls")
    for c in get_children():
        balls.push_back(c as HistoryBall)

func play_next_ball(answer_correct: bool):
    await balls[current_index].play_animation(answer_correct)
    current_index += 1
    
