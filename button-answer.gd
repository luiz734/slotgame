extends NinePatchRect

# todo: use custom class for data
signal clicked(data: Dictionary)

var _is_hovering: bool = false
var _hover_duration_sec: float = 0.2
var _scale_normal: float = 1.0
var _scale_hover: float = 1.05

@onready var hitbox = $Hitbox

func _ready():
    assert(hitbox, "missing hitbox reference")

    mouse_entered.connect(func():
        _is_hovering = true
        var tween = get_tree().create_tween()
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
        tween.tween_method(func(v: float):
            scale = Vector2(v, v)
            , _scale_normal, _scale_hover, _hover_duration_sec)

    )

    mouse_exited.connect(func():
        _is_hovering = false
        var tween = get_tree().create_tween()
        tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
        tween.tween_method(func(v: float):
            scale = Vector2(v, v)
            , _scale_hover, _scale_normal, _hover_duration_sec)
    )

func _process(delta):
    if _is_hovering and Input.is_action_just_pressed("click"):
        clicked.emit({})

func _on_mouse_entered():
    pass # Replace with function body.
