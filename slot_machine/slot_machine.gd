extends Node2D
class_name SlotMachine

var SlotTile: PackedScene = preload("res://slot_tile/slot_tile.tscn")
# Stores the SlotTile's SPIN_UP animation distance
const SPIN_UP_DISTANCE = 100.0
signal stopped
# signal stopped_all(tiles)
var _stopped_count = 0

@export var pictures_row1: Array[SlotTileData] = [
    preload("res://resources/xp.tres"),
    preload("res://resources/kanban.tres"),
    preload("res://resources/lean.tres"),
    preload("res://resources/manifesto_agil.tres"),
    preload("res://resources/scrum.tres"),
]

@export var pictures_row2: Array[SlotTileData] = [
    preload("res://resources/facil.tres"),
    preload("res://resources/medio.tres"),
    preload("res://resources/dificil.tres"),
]

@export var pictures_row3: Array[SlotTileData] = [
    preload("res://resources/bomb.tres"),
    preload("res://resources/arrow_right.tres"),
    preload("res://resources/2x.tres"),
    preload("res://resources/brain.tres"),
    preload("res://resources/clock.tres"),
    preload("res://resources/double_arrow.tres"),
]

@export_range(1, 20) var reels: int = 5
@export_range(1, 20) var tiles_per_reel: int = 4
# Defines how long the reels are spinning
@export_range(0.0, 10.0) var runtime: float = 1.0
# Defines how fast the reels are spinning
@export_range(0.1, 10.0) var speed: float = 5.0
# Defines the start delay between each reel
@export_range(0.0, 2.0) var reel_delay: float = 0.2

# Adjusts tile size to viewport
#@onready var size := get_viewport_rect().size
#@onready var tile_size := size / Vector2(reels, reels)
@onready var tile_size := Vector2(300, 300)
# Normalizes the speed for consistancy independent of the number of tiles
@onready var speed_norm := speed * tiles_per_reel
# Add additional tiles outside the viewport of each reel for smooth animation
# Add it twice for above and below the grid
@onready var extra_tiles := int(ceil(SPIN_UP_DISTANCE / tile_size.y) * 2)
@onready var pivot = $SubViewport/pivot
# Stores the actual number of tiles
@onready var rows := tiles_per_reel + extra_tiles

enum State { OFF, ON, STOPPED }
var state = State.OFF
var result := {}

# Stores SlotTile instances
var tiles := []
# Stores the top left corner of each grid cell
var grid_pos := []

# 1/speed*runtime*reels times
# Stores the desured number of movements per reel
@onready var expected_runs: int = int(runtime * speed_norm)
# Stores the current number of movements per reel
var tiles_moved_per_reel := []
# When force stopped, stores the current number of movements
var runs_stopped := 0
# Store the runs independent of how they are achieved
var total_runs: int
var spacement := Vector2(0, 0)

var questions_reader = preload("res://question/question_data.gd")
var questions_matrix = []

func _ready():
    questions_matrix = questions_reader.new().load_text_file("res://question/question.txt")
    
    pivot.position.x -= tile_size.x
    # Initializes grid of tiles
    for col in reels:
        grid_pos.append([])
        tiles_moved_per_reel.append(0)
        for row in range(rows):
            # Position extra tiles above and below the viewport
            var pos: Vector2 = Vector2(col, row - 0.5 * extra_tiles) * (tile_size + spacement)
            grid_pos[col].append(pos)
            _add_tile(col, row)


# Stores and initializes a new tile at the given grid cell
func _add_tile(col: int, row: int) -> void:
    tiles.append(SlotTile.instantiate())
    var tile := get_tile(col, row)
    tile.tween_completed.connect(_on_tile_moved)
    tile.set_data(_randomTexture(col))
    tile.set_size(tile_size)
    tile.position = grid_pos[col][row]
    tile.set_speed(speed_norm)
    pivot.add_child(tile)


# Returns the tile at the given grid cell
func get_tile(col: int, row: int) -> SlotTile:
    return tiles[(col * rows) + row]


func start() -> void:
    # Only start if it is not running yet
    if state == State.OFF:
        state = State.ON
        _stopped_count = 0
        total_runs = expected_runs
        # Ask server for result
        _get_result()
        # print(result)
        # Spins all reels
        for reel in reels:
            _spin_reel(reel)
            # Spins the next reel a little bit later
            if reel_delay > 0:
                await get_tree().create_timer(reel_delay).timeout


# Force the machine to stop before runtime ends
func stop():
    # Tells the machine to stop at the next possible moment
    state = State.STOPPED
    # Store the current runs of the first reel
    # Add runs to update the tiles to the result images
    runs_stopped = current_runs()
    total_runs = runs_stopped + tiles_per_reel + 1


# Is called when the animation stops
func _stop() -> void:
    for reel in reels:
        tiles_moved_per_reel[reel] = 0
    state = State.OFF
    _stopped_count += 1
    stopped.emit()
    if _stopped_count == reels + 1:
        Globals.slot_stopped.emit([get_tile(0, 1).data.id, get_tile(1, 1).data.id, get_tile(2, 1).data.id])

    var questions = []
    if _stopped_count == 1:
        for i in questions_matrix:
            if i[0] == get_tile(0, 1).data.id and i[1] == get_tile(1, 1).data.id:       
                var values = []
                for a in i:
                    values.append(a.strip_edges().replace("[^a-zA-Z0-9\\s]", "").replace("\\", ""))
                questions.append(values)
        if questions.size() > 0:
            print(questions[randi_range(0, questions.size() - 1)])

# Starts moving all tiles of the given reel
func _spin_reel(reel: int) -> void:
    # Moves each tile of the reel
    for row in rows:
        _move_tile(get_tile(reel, row))


func _move_tile(tile: SlotTile) -> void:
    # Plays a spin up animation
    tile.spin_up()
    await tile.animation_finished
    # Moves reel by one tile at a time to avoid artifacts when going too fast
    tile.move_by(Vector2(0, tile_size.y))
    # The reel will move further through the _on_tile_moved function


#func _on_tile_moved(tile: SlotTile, _nodePath) -> void:
func _on_tile_moved(tile: SlotTile) -> void:
    # Calculates the reel that the tile is on
    var reel := int(tile.position.x / tile_size.x)
    # Count how many tiles moved per reel
    tiles_moved_per_reel[reel] += 1
    var reel_runs := current_runs(reel)

    # If tile moved out of the viewport, move it to the invisible row at the top
    if tile.position.y > grid_pos[0][-1].y:
        tile.position.y = grid_pos[0][0].y
    # Set a new random texture
    var current_idx = total_runs - reel_runs
    if current_idx < tiles_per_reel:
        var result_texture = pictures_row1[result.tiles[reel][current_idx]]
        #tile.set_texture(result_texture)
        #tile.set_texture(_randomTexture(reel))
    #else:
    tile.set_data(_randomTexture(reel))

    # Stop moving after the reel ran expected_runs times
    # Or if the player stopped it
    if state != State.OFF && reel_runs != total_runs:
        tile.move_by(Vector2(0, tile_size.y))
    else:  # stop moving this reel
        tile.spin_down()
        #print(current_runs(0))
        # When last reel stopped, machine is stopped
        #print(str(reel) + " - " + str(reels))
        if reel == reels - 1:
            _stop()


# Divide it by the number of tiles to know how often the whole reel moved
# Since this function is called by each tile, the number changes (e.g. for 6 tiles: 1/6, 2/6, ...)
# We use ceil, so that both 1/7, as well as 7/7 return that the reel ran 1 time
func current_runs(reel := 0) -> int:
    return int(ceil(float(tiles_moved_per_reel[reel]) / rows))


func _randomTexture(row: int):
    assert(row >= 0 and row <= 2, "Invalid row")
    if row == 0:
        return pictures_row1[randi() % pictures_row1.size()]
    elif row == 1:
        return pictures_row2[randi() % pictures_row2.size()]
    elif row == 2:
        return pictures_row3[randi() % pictures_row3.size()]


func _get_result() -> void:
    result = {"tiles": [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]}
