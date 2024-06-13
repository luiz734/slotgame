extends TextureProgressBar
class_name AnswerTimer

signal timeout

var _timeout_sec: float = 10.0
var _enabled = false

@onready var star_1: Sprite2D = $Star1
@onready var star_2: Sprite2D = $Star2
@onready var star_3: Sprite2D = $Star3

var SPRITE_FILLED = preload("res://ui/star-filled.png")
var SPRITE_EMPTY = preload("res://ui/star-empty.png")

var stars_perc = [0, 40, 70]
var last_perc = stars_perc.pop_back()

func _ready():
    assert(star_1, "Missing star_1 reference")
    assert(star_2, "Missing star_2 reference")
    assert(star_3, "Missing star_3 reference")
    value = max_value
    Globals.boost_used.connect(func(id):
        if id != "clock":
            return
        pause_10_seconds()
    )

func stop():
    _enabled = false

func get_pontuation():
    assert(not _enabled, "Timer must be stopped before")
    return len(stars_perc) + 1
    
func update_stars():
    if last_perc == 70:
        star_3.texture = SPRITE_EMPTY
    elif last_perc == 40:
        star_2.texture = SPRITE_EMPTY
    last_perc = stars_perc.pop_back()

func pause_10_seconds():
    _enabled = false
    await get_tree().create_timer(10.0).timeout
    _enabled = true

    
func _physics_process(delta):
    if not _enabled:
        return
    var x = 100.0 / _timeout_sec
    value -= delta * x
    if value <= last_perc:
        update_stars()
    if value <= 0.0:
        _enabled = false
        timeout.emit()
        
        # debug only
        #value = max_value
        
func reset_timer():
    stars_perc = [0, 40, 70]
    last_perc = stars_perc.pop_back()
    star_1.texture = SPRITE_FILLED
    star_2.texture = SPRITE_FILLED
    star_3.texture = SPRITE_FILLED
    value = max_value
    _enabled = true
