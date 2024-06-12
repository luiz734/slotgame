extends HBoxContainer

@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
    assert(label, "Missing label reference")
    GameState.state_changed.connect(func():
        label.text = "Você possui " + str(GameState.starts_amount)
    )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
