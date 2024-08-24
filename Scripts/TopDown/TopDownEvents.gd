extends Node

var current_tilemap_bounds: Array[ Vector2 ]
signal TileMapBoundsChanged( bounds : Array[Vector2])

func ChangeTileMapBounds(bounds : Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit(bounds)

signal dialogue_start
signal dialogue_end
signal reading_end
