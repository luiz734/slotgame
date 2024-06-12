extends TextureRect
class_name HistoryBall

var correct_sprite = preload("res://ui/ball-correct.png")
var wrong_sprite = preload("res://ui/ball-wrong.png")
@onready var sprite = $Sprite2D

func _ready():
    assert(sprite, "Missing sprite reference")


func play_animation(is_correct):
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_method(func(v: float):
        sprite.scale = Vector2(v, v)
        , 1.0, 0.0, 0.4
    )
    await tween.finished
    
    sprite.texture = correct_sprite if is_correct else wrong_sprite
    tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_method(func(v: float):
        sprite.scale = Vector2(v, v)
        , 0.0, 1.0, 1.0
    )
    await tween.finished
