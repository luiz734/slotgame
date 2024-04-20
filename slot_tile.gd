class_name SlotTile
extends Sprite2D

signal moved(tile)

func move_to(to: Vector2):
    var tween: Tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(self, "position", to, 1)
    await tween.finished
    moved.emit(self)
#
#func spin(texture_size: float):
    #tile.move_by(Vector2(0, sprite_size_y))


func move_by(by: Vector2):
  move_to(position + by)
  
func spin_up():
    var tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
    tween.tween_property(self, "position", position + Vector2(0, -64), 0.7)
    await tween.finished
  #
#func spin_down():
  #$Animations.play('SPIN_DOWN')
  #
