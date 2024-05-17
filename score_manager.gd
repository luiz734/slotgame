extends Node2D

@export var score_animation_prefab: PackedScene
@export var boost_buttons_parent: Control
var _boost_buttons: Array[BoostButton]

var _boosts: Array[SlotTileData] = [
    preload("res://resources/bomb.tres"),
    preload("res://resources/arrow_right.tres"),
    preload("res://resources/2x.tres"),
    preload("res://resources/brain.tres"),
    preload("res://resources/clock.tres"),
    preload("res://resources/double_arrow.tres"),
]

func _ready():
    assert(score_animation_prefab, "missing score animation prefab")
    for c in boost_buttons_parent.get_children():
        _boost_buttons.push_back(c as BoostButton)
    Globals.slot_stopped.connect(_on_slot_stopped)

func _on_slot_stopped(res):
    if _has_scored(res):
        var id = res[0]
        print("player has scored")
        var score_animation = score_animation_prefab.instantiate()
        score_animation.data = _get_data(id)
        score_animation.move_to = _get_position(id)
        add_child(score_animation)

func _get_position(id) -> Vector2:
    for b in _boost_buttons:
        if b.data.id == id:
            return b.global_position + b.size / 2.0
    return Vector2.ZERO
    
func _get_data(id) -> SlotTileData:
    for b in _boosts:
        if b.id == id:
            return b
    assert(false)
    return null
    
func _has_scored(res: Array) -> bool:
    var first = res[0]
    return res.all(func(x): return x == first)

