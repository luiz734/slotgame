extends Node2D
@export var tile_prefab: PackedScene
@export var n_tiles = 4
@export var speed := 128
@export var distance_before_reset := 300
@export var impulse_distance_before_play = -50
@export var vertical_separation = 20
@export var sprite_size_y = 128

enum State {spinning, stopped}
var state
var base_position_y = 0.0
var _tiles: Array[Node]
var tiles_moved = 2

var tiles_per_sec: float = 8
var movement_duration: float = 1.0 / tiles_per_sec
var tile_y_separation: float = 32.0

func _ready():
    assert(tile_prefab, "missing tile prefab")
    state = State.stopped
    _setup_tiles_before_first_spin()
    
    
func _process(delta):
    if Input.is_action_just_pressed("run"):
        if state == State.stopped:
            _spin()
            state = State.spinning
        else:
            print(_tiles[tiles_moved % n_tiles].name)
            state = State.stopped

# debug only
func D_get_color(i):
    if i == 0: return Color.RED
    if i == 1: return Color.GREEN
    if i == 2: return Color.BLUE
    if i == 3: return Color.BLACK
func D_get_n(i):
    if i == 0: return "RED"
    if i == 1: return "GREEN"
    if i == 2: return "BLUE"
    if i == 3: return "BLACK"

    
# Called after each individual tile move
# It will keep move the tile or runs the spin_down animation
func _on_tile_moved(t: SlotTile):
    var over_max_y = t.position.y > 128+64
    if over_max_y:
        t.position = Vector2(0, -sprite_size_y * (n_tiles - 2) - 50)
        tiles_moved += 1
    if state == State.spinning:
        t.move_by(Vector2(0, sprite_size_y), movement_duration)
    else:
        t.spin_down(movement_duration)  

func _setup_tiles_before_first_spin():
    for i in range(n_tiles):
        var tile = tile_prefab.instantiate()
        _tiles.push_back(tile)
        tile.position = Vector2(0, -i * (sprite_size_y))
        add_child(tile)
        tile.moved.connect(_on_tile_moved)
        tile.set_animation_speed_scale(tiles_per_sec * 0.4)
        # debug only
        tile.modulate = D_get_color(i)
        tile.name = D_get_n(i)
        
func _spin():
    # spin up animation
    for i in range(1, len(_tiles)):
        _tiles[i].spin_up(movement_duration)
    await _tiles[0].spin_up(movement_duration)
    # hardcode the amount before actual spinning
    #await get_tree().create_timer(1.0).timeout
    # spin all tiles
    # they will keep spinning until state change to "stopped"
    for tile in _tiles:
        tile.move_by(Vector2(0, sprite_size_y), movement_duration)
