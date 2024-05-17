extends Button

@onready var _owner: SlotMachine = owner as SlotMachine


func _ready():
    pressed.connect(func():
        Globals.slot_start.emit()
        _owner.start()
        disabled = true
    )
    Globals.slot_stopped.connect(func(tiles):
        disabled = false
    )
