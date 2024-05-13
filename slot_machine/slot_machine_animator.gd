extends Node2D

@export var animation_player: AnimationPlayer

var _visible_position: Vector2
var _hide_position: Vector2

var _is_hidden: bool = true

func _ready():
    assert(animation_player, "Missing animation_player")

    _hide_position = global_position
    _visible_position = global_position + Vector2(1000, 0)
    # owner.position = _hide_position

    Globals.slot_start.connect(func():
        animation_player.play("pull")
    )

func animation_enter():
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(owner, "global_position", _visible_position, 0.5)
    _is_hidden = false

func animation_exit():
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(owner, "global_position", _hide_position, 0.5)
    _is_hidden = true

func _process(delta):
    if Input.is_action_just_pressed("show_slot"):
        if _is_hidden:
            animation_enter()
        else:
            animation_exit()

