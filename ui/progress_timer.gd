extends TextureProgressBar
class_name AnswerTimer

signal timeout

var _timeout_sec: float = 50.0
var _enabled = true

func _ready():
    value = max_value

func _physics_process(delta):
    if not _enabled:
        return
    value -= delta * _timeout_sec
    if value <= 0.0:
        _enabled = false
        timeout.emit()
        
        # debug only
        #value = max_value
        
func reset_timer():
    value = max_value
    _enabled = true
