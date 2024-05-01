extends Node2D
signal wheel_stopped()

@export var tile_prefab: PackedScene
@export var speed := 128
@export var distance_before_reset := 300
@export var impulse_distance_before_play = -50
@export var vertical_separation = 20
@export var sprite_size_y = 128
@export var values: Array[String] = ["easy", "medium", "hard", "very hard"]

enum State {spinning, stopped}
var state
var base_position_y = 0.0
var _tiles: Array[Node]
var tiles_moved = 2
var n_tiles = -1

var tiles_per_sec: float = 1
var movement_duration: float = 1.0 / tiles_per_sec
var tile_y_separation: float = 32.0

func _ready():
    test_swap_random_tiles()
    assert(tile_prefab, "missing tile prefab")
    n_tiles = len(values)
    #assert(len(values) == n_tiles, "len(values) should match n_tiles")
    state = State.stopped
    _setup_tiles_before_first_spin()
    
    
func _process(delta):
    pass

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
    var over_max_y = t.position.y > 128+128
    if over_max_y:
        t.position = Vector2(0, -sprite_size_y * (n_tiles - 2) - 50 + 128)
        swap_random_tiles()
        tiles_moved += 1
    if state == State.spinning:
        t.move_by(Vector2(0, sprite_size_y), movement_duration)
    else:
        t.spin_down(movement_duration)  

func _setup_tiles_before_first_spin():
    for i in range(n_tiles):
        var tile = tile_prefab.instantiate()
        _tiles.push_back(tile)
        tile.position = Vector2(0, -i * (sprite_size_y) + sprite_size_y)
        tile.set_label_text(values[i])
        add_child(tile)
        tile.moved.connect(_on_tile_moved)
        tile.name = values[i]
        # debug only
        #tile.modulate = D_get_color(i)
        #tile.name = D_get_n(i)

func get_current_tile_index() -> int:
    return tiles_moved % n_tiles

func test_swap_random_tiles():
    return
    print(get_swapable_indexes(4, 7), [3,2,1,0])
    print(get_swapable_indexes(1, 7), [0,6,5,4])
    assert(get_swapable_indexes(4, 7) == [3,2,1,0])
    assert(get_swapable_indexes(1, 7) == [0,6,5,4])


func get_swapable_indexes(before_index: int, n: int):
    var swapable_indexes = []
    var current_tile_index = get_current_tile_index()
    var count = 0
    var index = (current_tile_index - 2) % n_tiles
    while count < n - 5:
        index = index - 1
        if index < 0:
            index = n_tiles - 1
        swapable_indexes.push_back(index)
        count += 1
    print(swapable_indexes)
    return swapable_indexes 
    

func swap_random_tiles():
    if n_tiles > 4:
        var current_tile_index = get_current_tile_index()    
        var swapable = get_swapable_indexes(current_tile_index, n_tiles)
        var index_a = swapable.pick_random()
        var index_b = swapable.pick_random()
        print(current_tile_index, values[index_a], values[index_b]) 
        var a_pos = _tiles[index_a].position
        _tiles[index_a].position = _tiles[index_b].position
        _tiles[index_b].position = a_pos    
        

func stop():
    state = State.stopped
       
func spin():
    state = State.spinning
    # spin up animation
    for i in range(1, len(_tiles)):
        _tiles[i].spin_up(movement_duration * 2.0)
    await _tiles[0].spin_up(movement_duration * 2.0)
    # hardcode the amount before actual spinning
    #await get_tree().create_timer(1.0).timeout
    # spin all tiles
    # they will keep spinning until state change to "stopped"
    for tile in _tiles:
        tile.move_by(Vector2(0, sprite_size_y), movement_duration)
