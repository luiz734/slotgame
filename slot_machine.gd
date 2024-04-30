extends Node2D

var wheel_difficulty
var wheel_subject
var wheel_modifier
var wheels = []

enum State {spinning, stopped}
var state = State.stopped
var lock_input = false

func _ready():
    wheels = get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
 if Input.is_action_just_pressed("run"):
    if lock_input: return
    if state == State.stopped:
        lock_input = true
        for wheel in wheels:
            wheel.spin()
            await get_tree().create_timer(0.2).timeout
        state = State.spinning
        lock_input = false
    else:
        for wheel in wheels:
            wheel.stop()
            await get_tree().create_timer(0.2).timeout
            
        state = State.stopped
