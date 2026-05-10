extends Control
@onready var single_grid : PackedScene = preload("res://Scenes/single_grid.tscn")
@onready var grid_container : GridContainer = get_node("GridContainer")
@onready var child_count = grid_container.columns * grid_container.columns
@onready var ref_image : Image = Image.load_from_file("res://Assets/fieldofsunflowers.png")
@onready var you_win : ColorRect = get_node("YouWin!")
var scrambled : bool = false
var scramble_count : int = 5
func _ready() -> void:
	you_win.hide()
	for i in range(64):
		var instance = single_grid.instantiate()
		grid_container.add_child(instance)
		
func _process(delta: float) -> void:
	if ref_image and scramble_count > 0:
		scramble_count -= 1
		breakdown_image()
	if Game.win_check >= 63:
		you_win.show()

func breakdown_image():
	var children_cells = grid_container.get_children()
	var cell : int = 0
	var y : int = 0
	var y_offset : int = 0
	var x_offset: int = 0
	var first : bool = true
	for i in range(64):
		var pixel = (i % 8)
		if pixel == 0 and !first:
			y += 1
			y_offset += 1
			x_offset = 0
		var color = ref_image.get_pixel(pixel + x_offset,y + y_offset)
		var color2 = ref_image.get_pixel(pixel + 1 + x_offset,y + y_offset)
		var color3 = ref_image.get_pixel(pixel + x_offset, y + 1 + y_offset)
		var color4 = ref_image.get_pixel(pixel + 1 + x_offset ,y + 1 + y_offset)
		children_cells[cell].set_colors([color,color2,color3,color4])
		for x in range(randi() % 3):
			children_cells[cell].rotate()
		cell += 1
		x_offset += 1
		if pixel == 7:
			first = false
