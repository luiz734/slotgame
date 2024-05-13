extends TextureRect

#@onready var sprite: Sprite2D = $Icon
var flip_pivot: Vector2 = Vector2(1.0, 1.0)

func _ready():
    #material.set_shader_parameter("scale",global_scale)
    Globals.slot_start.connect(play_pageflip_animation)
    
func play_pageflip_animation():
    var tween_x = get_tree().create_tween()
    tween_x.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
    tween_x.tween_method(func(x: float):
        flip_pivot.x = x
        , 1.0, -1.0, 1.5)

    var tween_y = get_tree().create_tween()
    tween_y.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    tween_y.tween_method(func(y: float):
        flip_pivot.y = y
        , 1.0, -2.0, 1.5)

    # debug only
    await tween_y.finished
    flip_pivot = Vector2(1.0, 1.0)


func _process(_delta):
    # var window_size: Vector2 = get_window().size
    # var norm_mouse_pos = owner.get_viewport().get_mouse_position() / window_size
    var norm_mouse_pos := flip_pivot
    print(norm_mouse_pos)
    # If you flip the X-axis of the Node displaying the viewport. 
    # Same for fliping Y.
    norm_mouse_pos.x = 1.0 - norm_mouse_pos.x
    var sprite_size = Vector2(1229.0, 613.0)
    #var sprite_size = Vector2(1.0, 1.0)
    norm_mouse_pos *= sprite_size
    # Prevents flickering 
    if norm_mouse_pos.x < 1.0: norm_mouse_pos.x = 1.0
    if norm_mouse_pos.y > 613.0: norm_mouse_pos.y = 613.0
    material.set_shader_parameter("mouse_pos", Vector2(norm_mouse_pos.x, norm_mouse_pos.y))

