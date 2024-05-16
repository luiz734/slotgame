extends ColorRect

@export var _overlay_color: Color
var _transition_sec: float = 0.2

func _ready():
    color = _overlay_color
    visible = false

    Globals.overlay_on.connect(func():
        # var tween = get_tree().create_tween()
        # tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
        # tween.tween_property(self, "color", _overlay_color, _transition_sec)
        # await tween.finished
        visible = true
    )

    Globals.overlay_off.connect(func():
        # var tween = get_tree().create_tween()
        # tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
        # tween.tween_property(self, "color", Color.TRANSPARENT, _transition_sec)
        # await tween.finished
        visible = false
    )

func _process(delta):
    pass
