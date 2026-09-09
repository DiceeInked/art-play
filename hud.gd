extends CanvasLayer

@onready var player = $"../Player"
@onready var palette = $"../Palette"
var status: Label
var background_picker: ColorPickerButton
var brush_picker: ColorPickerButton
var swatch_row: FlowContainer

func _ready() -> void:
	var panel := PanelContainer.new()
	panel.position = Vector2(18, 18)
	panel.size = Vector2(720, 178)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.063, 0.125, 0.92)
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 6)
	panel.add_child(layout)
	var title := Label.new()
	title.text = "ART PLAY"
	title.add_theme_color_override("font_color", Color("65f4d0"))
	title.add_theme_font_size_override("font_size", 20)
	layout.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "Draw the path. Then walk it.  •  Arrow keys pan the camera  •  R resets your drawing"
	subtitle.add_theme_color_override("font_color", Color("aec4e6"))
	subtitle.add_theme_font_size_override("font_size", 14)
	layout.add_child(subtitle)
	status = Label.new()
	status.add_theme_font_size_override("font_size", 14)
	layout.add_child(status)

	var picker_row := HBoxContainer.new()
	picker_row.add_theme_constant_override("separation", 10)
	layout.add_child(picker_row)
	background_picker = make_picker("Background", palette.background_color)
	background_picker.color_changed.connect(palette.set_background)
	picker_row.add_child(background_picker)
	brush_picker = make_picker("Brush", palette.brush_color)
	brush_picker.color_changed.connect(palette.set_brush)
	picker_row.add_child(brush_picker)
	var add_swatch := Button.new()
	add_swatch.text = "+ Save brush swatch"
	add_swatch.pressed.connect(func(): palette.add_swatch(palette.brush_color))
	picker_row.add_child(add_swatch)

	var swatch_label := Label.new()
	swatch_label.text = "Saved swatches  •  Click = brush  •  Right-click = background"
	swatch_label.add_theme_color_override("font_color", Color("aec4e6"))
	swatch_label.add_theme_font_size_override("font_size", 13)
	layout.add_child(swatch_label)
	swatch_row = FlowContainer.new()
	swatch_row.add_theme_constant_override("h_separation", 6)
	layout.add_child(swatch_row)
	palette.colors_changed.connect(refresh_palette)
	refresh_palette()

func make_picker(label: String, color: Color) -> ColorPickerButton:
	var picker := ColorPickerButton.new()
	picker.text = label
	picker.color = color
	picker.custom_minimum_size = Vector2(128, 30)
	return picker

func refresh_palette() -> void:
	background_picker.color = palette.background_color
	brush_picker.color = palette.brush_color
	for child in swatch_row.get_children():
		child.queue_free()
	for color in palette.swatches:
		var swatch := Button.new()
		swatch.custom_minimum_size = Vector2(28, 28)
		swatch.tooltip_text = "%s\nClick: brush\nRight-click: background" % color.to_html(false)
		var style := StyleBoxFlat.new()
		style.bg_color = color
		style.corner_radius_top_left = 5
		style.corner_radius_top_right = 5
		style.corner_radius_bottom_left = 5
		style.corner_radius_bottom_right = 5
		swatch.add_theme_stylebox_override("normal", style)
		swatch.pressed.connect(func(): palette.set_brush(color))
		swatch.gui_input.connect(func(event):
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
				palette.set_background(color)
		)
		swatch_row.add_child(swatch)

func _process(_delta: float) -> void:
	if player.edit_mode:
		status.text = "EDIT MODE  •  Draw terrain with left click  •  Right click erases"
	else:
		status.text = "PLAY MODE  •  Walk with A / D  •  Press Space to edit the world"
