extends Node2D

@onready var slot = $SlotMachine
@onready var roll_button = $Roll
@onready var output = $output

func _ready():
    slot.stopped_all.connect(_on_slot_machine_stopped)
    roll_button.pressed.connect(_on_Roll_button_down)
    slot.stopped_all.connect(func(slots):
        print(slots)
        output.text = str(slots)
    )

func _on_Roll_button_down():
    if roll_button.text == "Roll":
        slot.start()
        Globals.slot_start.emit()
        roll_button.text = "Stop"

func _on_slot_machine_stopped(slots):
    roll_button.text = "Roll"
