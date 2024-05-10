extends GutTest

var RandomScript = load("res://random.gd")
# var WheelPrefab = load("res://wheel.tscn")
# var SlotTilePrefab = load("res://slot_tile.tscn")

func test_pick_random():
    var r : UtilRandom = partial_double(RandomScript).new()
    assert_eq(r._pick_from_array(["a", "b", "c"], [0.2, 0.4, 0.4], 0.1), "a", "3 bellow")
    assert_eq(r._pick_from_array(["a", "b", "c"], [0.2, 0.4, 0.4], 0.2), "a", "3 exact")
    assert_eq(r._pick_from_array(["a", "b", "c"], [0.2, 0.4, 0.4], 0.3), "b", "3 above")
    assert_eq(r._pick_from_array(["a", "b"], [0.2, 0.4, 0.4], 0.3), r.Error.MISMATCHED_LEN, "mismatched len")
    assert_eq(r._pick_from_array(["a", "b", "c"], [0.2, 0.4, 0.9], 0.3), r.Error.WEIGHTS_NOT_NORMALIZED, "sum above 1.0")
    assert_eq(r._pick_from_array(["a", "b", "c"], [0.2, 0.4, 0.1], 0.3), r.Error.WEIGHTS_NOT_NORMALIZED, "sum bellow 1.0")
    assert_eq(r._pick_from_array(["a", "b", "c"], [0.2, 0.4, 0.4], -1.0), r.Error.OUT_OF_RANGE, "r < 0.0")
    assert_eq(r._pick_from_array([], [], 0.2), r.Error.EMPTY_ARRAY, "empty array")
# func test_get_swapable_indexes():
#     var double_wheel = partial_double(WheelPrefab).instantiate()
#     # visible_tile_index, n_tiles
#     assert_eq(double_wheel.get_swapable_indexes(0, 7), [2, 3, 4, 5], "index 0 visible")
#     assert_eq(double_wheel.get_swapable_indexes(6, 7), [1, 2, 3, 4], "index n_tiles-1 visible")
#     assert_eq(double_wheel.get_swapable_indexes(2, 4), [0], "no swapables")
#     assert_eq(double_wheel.get_swapable_indexes(3, 5), [0, 1], "1 swapable")
#
# func test_get_visible_tile_index():
#     var double_wheel = partial_double(WheelPrefab).instantiate()
#     #assert_eq(double_wheel.get_visible_tile_index(0), [2, 3, 4], "index 0 visible")
#     # visible_tile_index, n_tiles
