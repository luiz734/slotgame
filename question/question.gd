extends Node2D
class_name Question

@onready var page_flip: PageFlip = $FinalOutput
@onready var canvas_bg = $ContentViewport/CanvasFront
signal flip_finished

func _ready():
    assert(page_flip, "Missing page flip reference")
    assert(canvas_bg, "Missing canvas bg reference")
    canvas_bg.self_modulate = Color(randf(), randf(), randf())
    page_flip.flip_animation_finished.connect(func():
        flip_finished.emit()
    )
    
func flip_page():
    page_flip.play_pageflip_animation()
