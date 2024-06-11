extends ColorRect
class_name Transition

signal finished

var time = 0.0
var started = false
var reversed = false

func start():
    move_to_front()
    started = true
    reversed = false

func start_reversed():
    move_to_front()
    started = true
    reversed = true

func _physics_process(delta):
    if not started:
        return
    time += delta
    var actual_time = time if not reversed else 1.0 - time
    material.set_shader_parameter("progress", actual_time)
    if time > 1.0:
        finished.emit()
        time = 0.0
        started = false
