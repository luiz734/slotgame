extends Button

@onready var _owner: SlotMachine = owner as SlotMachine


func _ready():
    pressed.connect(func():
        if GameState.starts_amount > 0:
            Globals.slot_start.emit()
            _owner.start()
            disabled = true
            GameState.starts_amount -= 1
    )
    Globals.slot_stopped.connect(func(tiles):
        disabled = false
    )
