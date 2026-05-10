extends Node3D
var all_colors : Array
@onready var container = get_node("Container")
@onready var palette = get_node("UI/ColorContainer")
@onready var paint = get_node("UI/ButtonPicture/PaintButton")
@onready var swap = get_node("UI/ButtonPicture2/SwapButton")
@onready var block : PackedScene = load("res://Scenes/block.tscn")
@onready var camera : Camera3D = get_node("Container/Camera3D")
@onready var save_menu : ColorRect = get_node("SaveMenu")
@onready var confirm_menu : ColorRect = get_node("SaveMenu/Confirm")
@onready var painting_name_field : TextEdit = get_node("SaveMenu/PaintingName")
@onready var load_menu = get_node("UI/LoadMenu")
var columns : int = 10
var rows : int = 10
var blocks : Array = []
var save_data : SaveFile
func _ready() -> void:
	set_palette()
	if container.get_children().size() == all_colors.size():
		print("loaded")
	load_blocks(columns, rows)
	init_save_file()
	save_menu.hide()
	confirm_menu.hide()
	load_menu.hide()
			
func _process(delta: float) -> void:
	if Game.painting_mode:
		paint.flat = true
		swap.flat = false
	else:
		paint.flat = false
		swap.flat = true

func get_all_colors():
	for i in range(container.get_children().size()):
		all_colors.append(container.get_children()[i].color)

func set_palette():
	for i in range(palette.get_children().size()):
		palette.get_children()[i].color = Game.colors[i].albedo_color
		
func load_blocks(columns: int, rows: int):
	for y in columns:
		for x in rows:
			var instance = block.instantiate()
			container.add_child(instance)
			blocks.append(instance)
			instance.scale = instance.scale / 2
			instance.position.x += x * 1
			instance.position.z += y * 1
	camera.position.z += rows / 2
	camera.position.x += columns - 0.5
	camera.position.y += columns - 1

func init_save_file():
	if ResourceLoader.exists("user://paintings.tres"):
		save_data = ResourceLoader.load("user://paintings.tres")
	else:
		save_data = SaveFile.new()

func save_painting(name : String):
	var painting = PaintingData.new()
	painting.painting_name = name
	for b in blocks:
		painting.block_colors.append(b.get_color_indices())
	save_data.paintings.append(painting)

func save_file():
	ResourceSaver.save(save_data, "user://paintings.tres")

func load_painting(index : int):
	var painting : PaintingData = save_data.paintings[index]
	for i in range(blocks.size()):
		blocks[i].set_colors_by_index(painting.block_colors[i])
		

func _on_paint_button_pressed() -> void:
	Game.painting_mode = true



func _on_swap_button_pressed() -> void:
	Game.painting_mode = false


func _on_color_button_1_pressed() -> void:
	col(1)
func _on_color_button_2_pressed() -> void:
	col(2)
func _on_color_button_3_pressed() -> void:
	col(3)
func _on_color_button_4_pressed() -> void:
	col(4)
func _on_color_button_5_pressed() -> void:
	col(5)
func _on_color_button_6_pressed() -> void:
	col(6)
func col(color_num: int):
	Game.set_color(Game.colors[color_num-1])
	Game.painting_mode = true


func _on_save_button_pressed() -> void:
	save_menu.show()
	


func _on_yes_pressed() -> void:
	var name = painting_name_field.text
	for p in save_data.paintings:
		if p.painting_name == name:
			confirm_menu.show()
			return
	save_painting(name)
	save_file()
	save_menu.hide()


func _on_no_pressed() -> void:
	save_menu.hide()


func _on_yes_overwrite_pressed() -> void:
	var name = painting_name_field.text
	for i in range(save_data.paintings.size()):
		if save_data.paintings[i].painting_name == name:
			var painting = PaintingData.new()
			painting.painting_name = name
			for b in blocks:
				painting.block_colors.append(b.get_color_indices())
			save_data.paintings[i] = painting
			break
	save_file()
	confirm_menu.hide()
	save_menu.hide()


func _on_load_button_pressed() -> void:
	load_menu.show_menu(self, save_data)
