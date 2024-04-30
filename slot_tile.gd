class_name SlotTile
extends Node2D

signal moved(tile)
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
    animation_player.speed_scale = 1.0 / (0.3 * 2.0)

func move_to(to: Vector2):
    var tween: Tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(self, "position", to, 0.3)
    await tween.finished
    moved.emit(self)
#
#func spin(texture_size: float):
    #tile.move_by(Vector2(0, sprite_size_y))

func move_by(by: Vector2):
  move_to(position + by)
  
func spin_up():
    animation_player.play("spin_up")
    await animation_player.animation_finished
    
func spin_down():
    animation_player.play("spin_down")
    await animation_player.animation_finished

