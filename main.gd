extends Node2D

@onready var slot = $SubViewportContainer/SubViewport/SlotMachine
@onready var roll_button = $Roll

func _ready():
    slot.stopped.connect(_on_slot_machine_stopped)
    roll_button.pressed.connect(_on_Roll_button_down)

func _on_Roll_button_down():
  if roll_button.text == "Roll":
    slot.start()
    roll_button.text = "Stop"
  else:
    slot.stop()

func _on_slot_machine_stopped():
  roll_button.text = "Roll"
