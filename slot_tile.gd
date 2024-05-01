class_name SlotTile
extends Node2D

signal moved(tile)
@onready var label: Label = $Label
var target_position: Vector2


func _ready():
    assert(label, "missing label reference")
    
func set_label_text(value: String) -> void:
    await self.ready
    label.text = value

func move_to(to: Vector2, duration_sec: float):
    var tween: Tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(self, "position", to, duration_sec)
    await tween.finished
    moved.emit(self)
#
#func spin(texture_size: float):
    #tile.move_by(Vector2(0, sprite_size_y))

func move_by(by: Vector2, duration_sec: float):
  move_to(position + by, duration_sec)
  
func spin_up(duration_sec: float):
    var to = position - Vector2(0, 50.0)
    var tween: Tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(self, "position", to, duration_sec)
    await tween.finished
    #animation_player.play("spin_up")
    #await animation_player.animation_finished
    
func spin_down(duration_sec: float):
    var to = position - Vector2(0, 128.0 - 50.0)
    var tween: Tween = get_tree().create_tween()
    tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    tween.tween_property(self, "position", to, duration_sec)
    await tween.finished


