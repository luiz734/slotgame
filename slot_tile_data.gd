extends Resource
class_name SlotTileData


@export var texture: Texture2D:
    get:
        return texture
    set(v):
        texture = v
        
@export var id: String = "none":
    get:
        return id
    set(v):
        id = read_txt_file(v)
        
        
# Tirar daqui, e retornar a combinação de tópico e dificuldade 
# Criar outro resource, armazenar as perguntas em uma matriz
func read_txt_file(word: String) -> String:

    var file = FileAccess.open("res://questions.txt", FileAccess.READ)
    var content = file.get_as_text()
    
    var lines = content.split("\n")
    
    print(word)
    
    var value = null
    for line in lines:
        value = line.split(",")[0]
        print(value)
    
    file.close()
    
    return value

