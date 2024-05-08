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
