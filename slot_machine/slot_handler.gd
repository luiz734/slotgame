extends Line2D

@export var move_part: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    assert(move_part, "Missing moving part")

func _physics_process(delta):
    print(move_part.position)
    points[1] = move_part.global_position - global_position
