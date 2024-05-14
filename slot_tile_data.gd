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
        id = v
        
# Tirar daqui, e retornar a combinação de tópico e dificuldade 
# Criar outro resource, armazenar as perguntas em uma matriz


