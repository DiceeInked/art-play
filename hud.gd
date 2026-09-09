extends CanvasLayer

@onready var player = $"../Player"
@onready var palette = $"../Palette"

var status: Label
var mode_badge: Label
var editor: PanelContainer
var hex_input: LineEdit
var swatch_row: HBoxContainer
var selected_swatch := 0

func _ready() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	create_top_bar(root)
	create_bottom_bar(root)
	create_editor(root)
	palette.colors_changed.connect(refresh_palette)
	refresh_palette()

func create_top_bar(root: Control) -> void:
	var top_bar := ColorRect.new()
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_bar.offset_bottom = 54.0
	top_bar.color = Color(0.035, 0.063, 0.125, 0.94)
	root.add_child(top_bar)
	var content := MarginContainer.new()
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content.add_theme_constant_override("margin_left", 20)
	content.add_theme_constant_override("margin_right", 20)
	content.add_theme_constant_override("margin_top", 10)
	content.add_theme_constant_override("margin_bottom", 8)
	top_bar.add_child(content)
	var layout := HBoxContainer.new()
	content.add_child(layout)
	var title := Label.new()
	title.text = "ART PLAY"
	title.add_theme_color_override("font_color", Color("65f4d0"))
	title.add_theme_font_size_override("font_size", 20)
	layout.add_child(title)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_child(spacer)
	mode_badge = Label.new()
	mode_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	mode_badge.custom_minimum_size = Vector2(170, 0)
	mode_badge.add_theme_font_size_override("font_size", 14)
	layout.add_child(mode_badge)
	var palette_button := Button.new()
	palette_button.text = "Palette"
	palette_button.custom_minimum_size = Vector2(88, 32)
	palette_button.pressed.connect(func(): editor.visible = not editor.visible)
	layout.add_child(palette_button)

func create_bottom_bar(root: Control) -> void:
	var bottom_bar := ColorRect.new()
	bottom_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom_bar.offset_top = -42.0
	bottom_bar.color = Color(0.035, 0.063, 0.125, 0.94)
	root.add_child(bottom_bar)
	status = Label.new()
	status.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	status.add_theme_color_override("font_color", Color("dce8ff"))
	status.add_theme_font_size_override("font_size", 14)
	bottom_bar.add_child(status)

func create_editor(root: Control) -> void:
	editor = PanelContainer.new()
	editor.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	editor.position = Vector2(-344, 66)
	editor.size = Vector2(326, 250)
	editor.visible = false
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.09, 0.16, 0.98)
	style.border_color = Color("334a72")
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.set_content_margin_all(14)
	editor.add_theme_stylebox_override("panel", style)
	root.add_child(editor)
	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 8)
	editor.add_child(layout)
	var heading := Label.new()
	heading.text = "COLOR PALETTE"
	heading.add_theme_color_override("font_color", Color("65f4d0"))
	heading.add_theme_font_size_override("font_size", 16)
	layout.add_child(heading)
	var help := Label.new()
	help.text = "Choose one of five swatches, then edit its hex value."
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_theme_color_override("font_color", Color("aec4e6"))
	help.add_theme_font_size_override("font_size", 13)
	layout.add_child(help)
	swatch_row = HBoxContainer.new()
	swatch_row.add_theme_constant_override("separation", 8)
	layout.add_child(swatch_row)
	var hex_row := HBoxContainer.new()
	hex_row.add_theme_constant_override("separation", 8)
	layout.add_child(hex_row)
	var prefix := Label.new()
	prefix.text = "Hex"
	prefix.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hex_row.add_child(prefix)
	hex_input = LineEdit.new()
	hex_input.placeholder_text = "#65F4D0"
	hex_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hex_input.max_length = 9
	hex_input.text_submitted.connect(func(_text): apply_hex())
	hex_row.add_child(hex_input)
	var apply := Button.new()
	apply.text = "Apply"
	apply.pressed.connect(apply_hex)
	hex_row.add_child(apply)
	var background := Button.new()
	background.text = "Use selected color as background"
	background.pressed.connect(func(): palette.set_background(palette.swatches[selected_swatch]))
	layout.add_child(background)
	var reset := Button.new()
	reset.text = "Reset drawing (R)"
	reset.pressed.connect(func(): player.drawing.clear_canvas())
	layout.add_child(reset)

func refresh_palette() -> void:
	for child in swatch_row.get_children():
		child.queue_free()
	for index in range(palette.swatches.size()):
		var color = palette.swatches[index]
		var swatch := Button.new()
		swatch.custom_minimum_size = Vector2(48, 42)
		swatch.tooltip_text = color.to_html(false)
		var style := StyleBoxFlat.new()
		style.bg_color = color
		style.set_corner_radius_all(6)
		style.set_border_width_all(3 if index == selected_swatch else 1)
		style.border_color = Color.WHITE if index == selected_swatch else Color("334a72")
		swatch.add_theme_stylebox_override("normal", style)
		swatch.pressed.connect(select_swatch.bind(index))
		swatch_row.add_child(swatch)
	hex_input.text = palette.swatches[selected_swatch].to_html(true).to_upper()

func select_swatch(index: int) -> void:
	selected_swatch = index
	palette.set_brush(palette.swatches[index])

func apply_hex() -> void:
	var value := hex_input.text.strip_edges()
	if not value.begins_with("#"):
		value = "#" + value
	if not Color.html_is_valid(value):
		hex_input.tooltip_text = "Use a 6- or 8-digit hex value, such as #65F4D0."
		return
	hex_input.tooltip_text = ""
	palette.set_swatch(selected_swatch, Color.html(value))

func _process(_delta: float) -> void:
	if player.edit_mode:
		mode_badge.text = "EDIT MODE"
		mode_badge.add_theme_color_override("font_color", Color("ffd166"))
		status.text = "Left mouse draws  •  Right mouse erases  •  Space returns to Play mode  •  R resets"
	else:
		mode_badge.text = "PLAY MODE"
		mode_badge.add_theme_color_override("font_color", Color("65f4d0"))
		status.text = "A / D to walk  •  Space opens Edit mode  •  Arrow keys pan the camera"
