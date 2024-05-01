extends GutTest

var WheelScript = load("res://wheel.gd")
var WheelPrefab = load("res://wheel.tscn")
var SlotTilePrefab = load("res://slot_tile.tscn")

func test_create_n_tiles():
    var double_wheel = partial_double(WheelPrefab).instantiate()
    # sprite_size_y, vertical_separation, n_tiles
    assert_eq(double_wheel.get_tiles_position_y(100, 25, 4), [-125, -250, -375, -500], "failed 100, 25, 4")
    assert_eq(double_wheel.get_tiles_position_y(100, 25, 0), [], "failed n_tiles=0")
    assert_eq(double_wheel.get_tiles_position_y(100, 200, 2), [-300, -600], "failed larger separation")
    assert_eq(double_wheel.get_tiles_position_y(128, 0, 4), [-128, -256, -384, -512], "failed no separation")
    
func test_get_swapable_indexes():
    var double_wheel = partial_double(WheelPrefab).instantiate()
    # visible_tile_index, n_tiles
    assert_eq(double_wheel.get_swapable_indexes(0, 7), [2, 3, 4], "index 0 visible")
    assert_eq(double_wheel.get_swapable_indexes(6, 7), [1, 2, 3], "index n_tiles-1 visible")
    assert_eq(double_wheel.get_swapable_indexes(2, 4), [], "no swapables")
    assert_eq(double_wheel.get_swapable_indexes(3, 5), [0], "1 swapable")
