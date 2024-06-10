extends Node2D

@export var boost_buttons_parent: Control
var _boost_buttons: Array[BoostButton]

var _boosts: Array[SlotTileData] = [
    preload("res://ui/resources/bomb.tres"),
    preload("res://ui/resources/arrow_right.tres"),
    preload("res://ui/resources/2x.tres"),
    preload("res://ui/resources/brain.tres"),
    preload("res://ui/resources/clock.tres"),
    preload("res://ui/resources/double_arrow.tres"),
]

func _ready():
    assert(boost_buttons_parent, "missing boost_buttons_parent reference")
    for c in boost_buttons_parent.get_children():
        _boost_buttons.push_back(c as BoostButton)
    Globals.slot_stopped.connect(_on_slot_stopped)

func _on_slot_stopped(res):
    if _has_scored(res):
        var id = res[0]
        var current_boosts = GameState.avaliable_boosts
        current_boosts[id] += 1
        GameState.avaliable_boosts = current_boosts

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
    return true
    var first = res[0]
    return res.all(func(x): return x == first)

