extends Button

@onready var _owner: SlotMachine = owner as SlotMachine


func _ready():
    pressed.connect(func():
        Globals.slot_start.emit()
        _owner.start()
        disabled = true
    )
    _owner.stopped_all.connect(func(tiles):
        disabled = false
    )
