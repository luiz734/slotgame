extends Node
class_name UtilRandom

enum Error {
    MISMATCHED_LEN,
    OUT_OF_RANGE,
    WEIGHTS_NOT_NORMALIZED,
    EMPTY_ARRAY,
}

func pick_random_weight(arr: Array, weights: Array):
    var r := randf()
    return _pick_from_array(arr, weights, r)

func swap_random_pair(arr: Array, same_valid: bool):
    pass

func _pick_from_array(arr: Array, weights: Array, r: float):
    if r < 0.0 or r > 1.0:
        return Error.OUT_OF_RANGE
    if len(arr) < 1:
        return Error.EMPTY_ARRAY
    if len(arr) != len(weights):
        return Error.MISMATCHED_LEN
    if weights.reduce(func(accum, n): return accum + n, 0.0) != 1.0:
        return Error.WEIGHTS_NOT_NORMALIZED

    var sum = weights[0]
    var index = 0
    while sum < r:
        sum += weights[index]
        index += 1
    return arr[index]
