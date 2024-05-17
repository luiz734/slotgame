extends Node2D

@export var data: SlotTileData
var move_to: Vector2

func _ready():
    assert(data, "Missing data")
    var sprite = Sprite2D.new()

    sprite.texture = data.texture
    sprite.global_position = move_to - Vector2(0, -1080/2.0)
    sprite.scale = Vector2(0.5, 0.5)
    add_child(sprite)

    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
    tween.tween_property(sprite, "global_position", move_to, 1.0)
    await tween.finished
    
    Globals.boost_sprite_done.emit(data.id)
    
    tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(sprite, "modulate", Color.TRANSPARENT, 0.4)

    await tween.finished
    sprite.queue_free()
    queue_free()
