extends NinePatchRect
class_name QuestionOption

# todo: use custom class for data
signal clicked(data: Dictionary)

var _is_hovering: bool = false
var _hover_duration_sec: float = 0.2
var _scale_normal: float = 1.0
var _scale_hover: float = 1.05

const WRONG_COLOR: Color = Color("#ff6161")
const CORRECT_COLOR: Color = Color("#6eff61")

@onready var hitbox = $Hitbox
@onready var label = $MarginContainer/Label
@onready var animation_player = $AnimationPlayer
@onready var sound_correct: AudioStreamPlayer = $Correct
@onready var sound_wrong: AudioStreamPlayer = $Wrong

var is_correct: bool = false:
    set(value):
        is_correct = value 

func _ready():
    assert(hitbox, "missing hitbox reference")
    assert(label, "missing label reference")
    assert(animation_player, "Missing animation_player reference")

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
        #if is_correct:
        clicked.emit({
            "correct": is_correct,
            "button": self
        })

func _on_mouse_entered():
    pass # Replace with function body.

func unhide_all():
    self_modulate = Color.WHITE
    mouse_filter = MOUSE_FILTER_STOP
    label.visible = true
    
func hide_all():
    self_modulate = Color.TRANSPARENT
    mouse_filter = MOUSE_FILTER_IGNORE
    label.visible = false
    
func set_label(v: String):
    label.text = v

func reset_modulate():
    pass

func play_correct_answer_animation():
    animation_player.play("correct_answer")
    sound_correct.play()
    await animation_player.animation_finished
    modulate = Color.WHITE
    
func play_wrong_answer_animation():
    animation_player.play("wrong_answer")
    sound_wrong.play()
    await animation_player.animation_finished
    modulate = Color.WHITE
    
    
    
