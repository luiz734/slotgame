extends Resource

func load_text_file(file_path: String) -> Array:
    var file = FileAccess.open(file_path, FileAccess.READ)
    var matrix = []
    
    var content = file.get_as_text()
    
    var lines = content.split("\n")
    
    var value = null
    for line in lines:
        line = line.strip_edges()
        value = line.split(",")
        matrix.append(value)
    
    file.close()
    
    return matrix
