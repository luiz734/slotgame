extends Node2D
@export var tile_prefab: PackedScene

@export var n_tiles = 3
@export var speed := 500
@export var distance_before_reset := 300
@export var impulse_distance_before_play = -50
@export var vertical_separation = 20
@export var sprite_size_y = 128

enum State {running, stopped}
var state
var base_position_y = 0.0
var _tiles: Array[Node]
var tiles_moved = 1

func get_color(i):
    if i == 0: return Color.RED
    if i == 1: return Color.GREEN
    if i == 2: return Color.BLUE
func get_n(i):
    if i == 0: return "RED"
    if i == 1: return "GREEN"
    if i == 2: return "BLUE"
func _ready():
    assert(tile_prefab)
    state = State.stopped
    
    for i in range(n_tiles):
        var tile = tile_prefab.instantiate()
        tile.modulate = get_color(i)
        _tiles.push_back(tile)
        tile.position = Vector2(0, -i * (sprite_size_y))
        add_child(tile)
        tile.name = get_n(i)
        tile.moved.connect(func(t: SlotTile):
            if t.position.y > 64:
                    t.position = Vector2(0, -sprite_size_y * (n_tiles - 1))
                    tiles_moved += 1
            if state == State.running:
                t.move_by(Vector2(0, sprite_size_y))
            else:
                t.spin_down()
   
        )
        
func spin():
    #for i in range(1, len(_tiles)):
        #_tiles[i].spin_up()
    #await _tiles[0].spin_up()
    for tile in _tiles:
        tile.move_by(Vector2(0, sprite_size_y))
       
    

func _process(delta):
    if Input.is_action_just_pressed("run"):
        if state == State.stopped:
            spin()
            state = State.running
        else:
            print(_tiles[tiles_moved% n_tiles].name)
            state = State.stopped

func _physics_process(delta):
    pass
    #if state == "RUNNING":
        #base_position_y += speed * delta
        #if base_position_y > distance_before_reset:
            #base_position_y = 0
        #
        #for i in range(len(_tiles)):
            #var tile = _tiles[i]
            #tile.position.y += delta * speed
            #var pos_y = base_position_y + sprite_size_y * i
            #tile.position.y = pos_y
