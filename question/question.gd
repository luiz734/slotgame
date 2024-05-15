extends Node2D
class_name Question

@onready var page_flip: PageFlip = $FinalOutput
@onready var canvas_bg = $ContentViewport/CanvasFront
@onready var base_position := position

signal flip_finished

func _ready():
    assert(page_flip, "Missing page_flip reference")
    assert(canvas_bg, "Missing canvas_bg reference")

    page_flip.flip_animation_finished.connect(func():
        flip_finished.emit()
    )
    
    position.y = base_position.y - 1000.0
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(self, "position", base_position, 1.0)
    
    
    
func flip_page():
    page_flip.play_pageflip_animation()
