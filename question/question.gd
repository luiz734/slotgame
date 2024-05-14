extends Node2D
class_name Question

@onready var page_flip: PageFlip = $FinalOutput
@onready var canvas_bg = $ContentViewport/CanvasFront
@onready var page_top = $ContentViewport/CanvasTop
@onready var difficulty_ball = $ContentViewport/DifficultyBall
signal flip_finished

func red_yelllow_or_green():
    return [Color.RED, Color.YELLOW, Color.GREEN].pick_random()

func _ready():
    assert(page_flip, "Missing page_flip reference")
    assert(canvas_bg, "Missing canvas_bg reference")
    assert(page_top, "Missing page_top reference")
    assert(difficulty_ball, "Missing difficulty_ball reference")
    # todo: use color palette
    page_top.self_modulate = Color(randf(), randf(), randf())
    difficulty_ball.self_modulate = red_yelllow_or_green()
    page_flip.flip_animation_finished.connect(func():
        flip_finished.emit()
    )
    
func flip_page():
    page_flip.play_pageflip_animation()
