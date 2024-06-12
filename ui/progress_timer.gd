extends TextureProgressBar
class_name AnswerTimer

signal timeout

var _timeout_sec: float = 30.0
var _enabled = false

func _ready():
    value = max_value

func stop():
    _enabled = false
    
func _physics_process(delta):
    if not _enabled:
        return
    var x = 100.0 / _timeout_sec
    value -= delta * x
    if value <= 0.0:
        _enabled = false
        timeout.emit()
        
        # debug only
        #value = max_value
        
func reset_timer():
    value = max_value
    _enabled = true
