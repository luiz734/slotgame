extends TextureProgressBar

signal timeout

var _timeout_sec: float = 10.0

func _ready():
    value = max_value

func _physics_process(delta):
    value -= delta * _timeout_sec
    if value <= 0.0:
        timeout.emit()
        # debug only
        value = max_value
