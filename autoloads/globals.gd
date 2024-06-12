extends Node

signal slot_start
signal slot_stopped(res)
signal slot_scored

signal boost_sprite_done(id)

signal overlay_on
signal overlay_off

func _process(delta):
    if Input.is_action_just_pressed("quit"):
        get_tree().quit(0)

var game_just_run: bool = true

enum WheelDifficulty {
    EASY,
    NORMAL,
    HARD,
    VERY_HARD,
}
