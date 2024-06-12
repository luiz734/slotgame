extends Resource
class_name UtilRandom

enum Error {
    MISMATCHED_LEN,
    OUT_OF_RANGE,
    WEIGHTS_NOT_NORMALIZED,
    EMPTY_ARRAY,
}

var fail_count = 0
#var weights = [0.16, 0.16, 0.16, 0.16, 0.16, 0.16]
var base_weights: Array
var weights: Array
var indexes = [0, 1, 2, 3, 4, 5]

func _init():
    randomize()
    
func adjust_weights():
    var new_weights = []
    var total_weight = 0
    var increase_factor = 0.2 * fail_count  # Adjust this factor as needed
    increase_factor = min(increase_factor, 0.6)  # Ensure it doesn't go too high

    # Select the one to be lucky
    var lucky_index = choose_weighted_item(indexes, weights)

    for i in range(weights.size()):
        var new_weight
        if i == lucky_index:
            new_weight = weights[i] + increase_factor
            new_weight = min(new_weight, 1.0)  # Ensure it doesn't exceed 1.0
        else:
            new_weight = (weights[i] * (1 - increase_factor / (weights.size() - 1)))
            new_weight = max(new_weight, 0.0)  # Ensure it doesn't drop below 0.0

        new_weights.append(new_weight)
        total_weight += new_weight

    # Normalize the new weights
    for i in range(new_weights.size()):
        new_weights[i] /= total_weight
    
    weights = new_weights
    fail_count += 1
    return new_weights
    
func pick_random(items: Array):
    assert(len(weights) > 0, "Weights not initialized")
    var r := randf()
    var selected = choose_weighted_item(items, weights)
    #print(weights)
    return selected
    
func reset_weights():
    weights = base_weights 

func swap_random_pair(arr: Array, same_valid: bool):
    pass

func choose_weighted_item(items, weights):
    var total_weight = 0.0
    var cumulative_weights = []

    # Calculate the cumulative weights
    for weight in weights:
        total_weight += weight
        cumulative_weights.append(total_weight)

    # Generate a random number in the range [0, total_weight)
    var random_number = randf() * total_weight

    # Find the item corresponding to the random number
    for i in range(cumulative_weights.size()):
        if random_number < cumulative_weights[i]:
            return items[i]

    # Fallback (shouldn't happen if weights are correctly normalized)
    return items[0]
    
func _pick_from_array(arr: Array, weights: Array, r: float):
    if r < 0.0 or r > 1.0:
        return Error.OUT_OF_RANGE
    if len(arr) < 1:
        return Error.EMPTY_ARRAY
    if len(arr) != len(weights):
        return Error.MISMATCHED_LEN
    #if weights.reduce(func(accum, n): return accum + n, 0.0) != 1.0:
        #return Error.WEIGHTS_NOT_NORMALIZED

    var sum = weights[0]
    var index = 0
    while sum < r:
        sum += weights[index]
        index += 1
    return arr[index-1]
