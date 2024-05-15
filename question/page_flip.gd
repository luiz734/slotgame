extends TextureRect
class_name PageFlip

## Setup
# There are 2 viewport for this scene works and allow change the shader direction
# 
# ContentViewport is where what you want to display goes
# Note that the viewport size has and extra Vector(200, 200) space to be able to show the animation
# This is necessary because the animation happens outside the boundaries
# Consequently, all the other viewports and texture rects adjusts their sizes/position to keep things displaying normally
#
# PageFlipViewport is only necessary if your want to be able to flip the shader animation
# The default comes form here https://godotshaders.com/shader/page-flip-with-transparent-background/
# Out of the box, it only works flipping bottom-left to top-right animation 
# Using an extra viewport, you can flip some axis after aplying the shader
# Then you can flip it again to unmirror the content

signal flip_animation_finished
@export var flip_x_axis = true
@onready var rect_size: Vector2 = size

# I have no ideia why 1.49
# See the FINDING THE PIVOT bellow to more details
var flip_pivot: Vector2 = Vector2(1.49, 1.0)
var base_pivot = flip_pivot
var _flip_duration_sec: float = 1.5

func _ready():
    print(size)
    #material.set_shader_parameter("scale",global_scale)
    pass
    
func play_pageflip_animation():

    var tween_x = get_tree().create_tween()
    tween_x.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
    tween_x.tween_method(func(x: float):
        flip_pivot.x = x
        , base_pivot.x, -base_pivot.x, _flip_duration_sec)

    var tween_y = get_tree().create_tween()
    tween_y.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
    tween_y.tween_method(func(y: float):
        flip_pivot.y = y
        , base_pivot.y, -base_pivot.y, _flip_duration_sec)

    await tween_y.finished
    flip_animation_finished.emit()


func _process(_delta):
    var norm_mouse_pos = flip_pivot
    
    # FINDING THE PIVOT
    # Uncoment the next 4 line if the flip animation looks weird
    # Try to find the value for the norm_mouse_pos where the
    # page looks normal (without aby bends)
    # var window_size: Vector2 = get_window().size
    # var norm_mouse_pos = owner.get_viewport().get_mouse_position() / window_size
    # print(norm_mouse_pos)
    
    # If you flip the X-axis of the Node displaying the viewport. 
    # Same for fliping Y.
    if flip_x_axis:
        norm_mouse_pos.x = base_pivot.x - norm_mouse_pos.x
        
    var sprite_size = rect_size
    norm_mouse_pos *= sprite_size
    # Prevents flickering
    # Only usefull when debugging
    #if norm_mouse_pos.x < 1.0: norm_mouse_pos.x = 1.0
    #if norm_mouse_pos.y > 913.0: norm_mouse_pos.y = 913.0
    
    # debug
    if material:
        material.set_shader_parameter("mouse_pos", Vector2(norm_mouse_pos.x, norm_mouse_pos.y))

