extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
    GameState.state_changed.connect(func():
        text = ""
        #text += GameState.current_question
        #text += GameState.avaliable_boosts
        text += str(GameState.correct_answers)
        text += str(GameState.wrong_answers)
    )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
