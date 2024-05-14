extends Node2D
signal wheel_stopped()

@export var tile_prefab: PackedScene
@export var speed: int = 32
@export var distance_before_reset := 300
@export var impulse_distance_before_play = -50
@export var vertical_separation = 20
@export var sprite_size_y = 128
@export var values: Array[String] = ["easy", "medium", "hard"]

@onready var D_glass = $DebugGlass
const BELLOW_VISIBLE = 1

var tiles_base_y_position: Array[int]

enum State {spinning, stopped}
var state
var base_position_y = 0.0
var _tiles: Array[Node]
var current_visible = 2
var n_tiles = -1

var tiles_per_sec: float = 1
var movement_duration: float = 1.0 / tiles_per_sec
var tile_y_separation: float = 32.0

func _ready():
    seed(0)
    assert(tile_prefab, "missing tile prefab")
    n_tiles = len(values)
    tiles_base_y_position = get_tiles_position_y(sprite_size_y, vertical_separation, n_tiles)
    state = State.spinning
    
    D_glass.size = Vector2((sprite_size_y + 2*vertical_separation) * 2, sprite_size_y + 2*vertical_separation)
    D_glass.position.x = -(sprite_size_y + 2*vertical_separation) 
    D_glass.position.y = get_visible_y_position() + (sprite_size_y + 2*vertical_separation) / 2.0 - vertical_separation
    
    _setup_tiles_before_first_spin()
   
func get_tiles_position_y(sprite_size: int, vertical_separation: int, n_tiles: int) -> Array[int]:
    var positions_y: Array[int] = []
    for i in range(n_tiles):
        var new_pos_y = (sprite_size + vertical_separation) * (i + 1)
        # up is negative
        new_pos_y = -new_pos_y
        positions_y.push_back(new_pos_y)
    return positions_y

func _setup_tiles_before_first_spin():
    for i in range(n_tiles):
        var tile = tile_prefab.instantiate()
        _tiles.push_back(tile)
        tile.position.y = tiles_base_y_position[i]
        tile.set_label_text(values[i])
        add_child(tile)
        tile.name = values[i]

# TESTED
func get_swapable_indexes(visible_tile_index: int, n_tiles: int) -> Array[int]:
    var swapable_indexes: Array[int] = []
    var count = 0
    var index = (visible_tile_index + 1) % n_tiles
    while count < n_tiles - 3:
        index = (index + 1) % n_tiles
        if index >= n_tiles:
            index = 0
        swapable_indexes.push_back(index)
        count += 1
    print(swapable_indexes)
    return swapable_indexes 

func get_visible_tile_index(current_visible: int) -> int:
    return current_visible + n_tiles - BELLOW_VISIBLE
    
func swap_random_tiles():
    var swapable = get_swapable_indexes(current_visible, n_tiles)
    if len(swapable) < 2:
        return
    var index_a = swapable.pick_random()
    var index_b = swapable.pick_random()
    print(current_visible, "->", values[index_a], " ", values[index_b]) 
    var a_pos = _tiles[index_a].position
    _tiles[index_a].position = _tiles[index_b].position
    _tiles[index_b].position = a_pos
    var tmp = _tiles[index_a]
    _tiles[index_a] = _tiles[index_b]
    _tiles[index_b] = tmp
        

func stop():
    state = State.stopped
    speed = 800.0
       
func spin():
    state = State.spinning
    speed = 800.0
    # spin up animation
    #for i in range(1, len(_tiles)):
        #_tiles[i].spin_up(movement_duration * 2.0)
    #await _tiles[0].spin_up(movement_duration * 2.0)
    # hardcode the amount before actual spinning
    #await get_tree().create_timer(1.0).timeout
    # spin all tiles
    # they will keep spinning until state change to "stopped"
    #for tile in _tiles:
        #tile.move_by(Vector2(0, sprite_size_y), movement_duration)
    #move_wheel(movement_duration)

func _physics_process(delta):
    move_wheel(delta)

func get_visible_y_position():
    return tiles_base_y_position[BELLOW_VISIBLE + 1]

func move_wheel(delta: float):
    if state == State.spinning:
        for i in range(n_tiles):
            var t = _tiles[i]
            t.position.y += delta * speed
            if t.position.y > 0:
                t.position.y = tiles_base_y_position[n_tiles - 1]
                swap_random_tiles()
                current_visible  = (current_visible + 1) % n_tiles
           


#func move_by(by: Vector2, duration_sec: float):
  #move_to(position + by, duration_sec)
  
#func spin_up(duration_sec: float):
    #var to = position - Vector2(0, 50.0)
    #var tween: Tween = get_tree().create_tween()
    #tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    #tween.tween_property(self, "position", to, duration_sec)
    #await tween.finished
    ##animation_player.play("spin_up")
    ##await animation_player.animation_finished
    #
#func spin_down(duration_sec: float):
    #var to = position - Vector2(0, 128.0 - 50.0)
    #var tween: Tween = get_tree().create_tween()
    #tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
    #tween.tween_property(self, "position", to, duration_sec)
    #await tween.finished

