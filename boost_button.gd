extends TextureButton
class_name BoostButton

@export var data: SlotTileData

var _hover_duration_sec: float = 0.2
var _scale_normal: float = 1.0
var _scale_hover: float = 1.2

@export var _avaliable_uses = 0:
    set(v):
        _avaliable_uses = v
        if _avaliable_uses == 0:
            material.set_shader_parameter("enabled", true)
            self_modulate.a = 0.6
            disabled = true
        else:
            material.set_shader_parameter("enabled", false)
            self_modulate.a = 1.0
            disabled = false
    get:
        return _avaliable_uses

# Called when the node enters the scene tree for the first time.
func _ready():
    assert(data, "Missing data")
    # _avaliable_uses = 0
    _avaliable_uses = _avaliable_uses
    texture_normal = data.texture
    pressed.connect(func():
        # debug
        _avaliable_uses += 1      
    )

    mouse_entered.connect(func():
        if disabled: return
        # _is_hovering = true
        var tween = get_tree().create_tween()
        tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
        tween.tween_method(func(v: float):
            scale = Vector2(v, v)
            , _scale_normal, _scale_hover, _hover_duration_sec)

    )

    mouse_exited.connect(func():
        if disabled: return
        # _is_hovering = false
        var tween = get_tree().create_tween()
        tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
        tween.tween_method(func(v: float):
            scale = Vector2(v, v)
            , _scale_hover, _scale_normal, _hover_duration_sec)
    )
    
    GameState.state_changed.connect(func():
        for boost_id in GameState.avaliable_boosts:
            if boost_id == data.id:
                _avaliable_uses = GameState.avaliable_boosts[boost_id]   
    )
    Globals.boost_sprite_done.connect(_on_boost_sprite_done)

func _on_boost_sprite_done(id):
    if id == data.id:
        _avaliable_uses += 1
