extends Node2D
class_name SlotTile

signal tween_completed(tile: SlotTile)
signal animation_finished

@onready var sprite: Sprite2D = $pivot/Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var tween_speed_scale: float = 1.0
var data: SlotTileData = null

var size: Vector2


func _ready():
    animation_player.animation_finished.connect(func(x): animation_finished.emit())


func set_data(data: SlotTileData):
    if not sprite:
        await ready
    self.data = data
    #assert(tex.load_path != sprite.texture.load_path)
    sprite.texture = data.texture
    set_size(size)


func set_size(new_size: Vector2):
    if not sprite:
        await ready
    size = new_size
    sprite.scale = size / sprite.texture.get_size()


func set_speed(speed):
    tween_speed_scale = speed


func move_to(to: Vector2):
    var tween = get_tree().create_tween()
    tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
    tween.set_speed_scale(tween_speed_scale)
    tween.tween_property(self, "position", to, 1.0)
    await tween.finished
    tween_completed.emit(self)


func move_by(by: Vector2):
    move_to(position + by)


func spin_up():
    animation_player.play("spin_up")


func spin_down():
    animation_player.play("spin_down")
