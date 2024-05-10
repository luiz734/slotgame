extends NinePatchRect

var a = true

func _ready():
    swap()

func swap():
    if a: 
        region_rect = Rect2(384, 0, 384, 384)
    else:
        region_rect = Rect2(0, 0, 384, 384)
    a = not a
    await get_tree().create_timer(0.2).timeout.connect(swap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
