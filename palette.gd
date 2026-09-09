extends Node

signal colors_changed

var background_color := Color("0b1020")
var brush_color := Color("65f4d0")
const SWATCH_COUNT := 5
const DEFAULT_SWATCHES: Array[Color] = [
	Color("65f4d0"),
	Color("ff6ba6"),
	Color("ffd166"),
	Color("8b7cff"),
	Color("ffffff"),
]
var swatches: Array[Color] = DEFAULT_SWATCHES.duplicate()

const SAVE_PATH := "user://art_play_palette.cfg"

func _ready() -> void:
	load_palette()

func set_background(color: Color) -> void:
	background_color = color
	save_palette()
	colors_changed.emit()

func set_brush(color: Color) -> void:
	brush_color = color
	save_palette()
	colors_changed.emit()

func set_swatch(index: int, color: Color) -> void:
	if index < 0 or index >= swatches.size():
		return
	swatches[index] = color
	brush_color = color
	save_palette()
	colors_changed.emit()

func save_palette() -> void:
	var config := ConfigFile.new()
	config.set_value("colors", "background", background_color.to_html())
	config.set_value("colors", "brush", brush_color.to_html())
	var stored_swatches: Array[String] = []
	for color in swatches:
		stored_swatches.append(color.to_html())
	config.set_value("colors", "swatches", stored_swatches)
	config.save(SAVE_PATH)

func load_palette() -> void:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return
	background_color = Color(config.get_value("colors", "background", background_color.to_html()))
	brush_color = Color(config.get_value("colors", "brush", brush_color.to_html()))
	var stored_swatches = config.get_value("colors", "swatches", [])
	if stored_swatches is Array:
		swatches.clear()
		for value in stored_swatches:
			if swatches.size() >= SWATCH_COUNT:
				break
			swatches.append(Color(value))
	while swatches.size() < SWATCH_COUNT:
		swatches.append(DEFAULT_SWATCHES[swatches.size()])
