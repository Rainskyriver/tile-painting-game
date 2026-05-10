extends ColorRect

@onready var painting_cell_scene = load("res://Scenes/painting_cell.tscn")
@onready var page_container : VBoxContainer = get_node("PageContainer")
@onready var page_label : Label = get_node("Label2")
@onready var next_button : Button = get_node("NextButton")
@onready var previous_button : Button = get_node("PreviousButton")

var page : int = 0
var game_scene : Node3D
var save_data : SaveFile

func show_menu(game : Node3D, data : SaveFile):
	game_scene = game
	save_data = data
	page = 0
	populate_page()
	show()

func populate_page():
	for child in page_container.get_children():
		child.queue_free()

	var total : int = save_data.paintings.size()
	var total_pages : int = max(1, ceil(total / 8.0))
	page_label.text = str(page + 1) + "/" + str(total_pages)
	previous_button.disabled = page == 0
	next_button.disabled = page >= total_pages - 1

	var start : int = page * 8
	for i in range(8):
		var cell = painting_cell_scene.instantiate()
		page_container.add_child(cell)
		var painting_index : int = start + i
		if painting_index < total:
			cell.load_data(save_data.paintings[painting_index], painting_index)
			cell.load_requested.connect(_on_cell_load_requested)
			cell.delete_requested.connect(_on_cell_delete_requested)

func _on_cell_load_requested(index : int):
	game_scene.load_painting(index)
	hide()

func _on_cell_delete_requested(index : int):
	save_data.paintings.remove_at(index)
	ResourceSaver.save(save_data, "user://paintings.tres")
	var total_pages : int = max(1, ceil(save_data.paintings.size() / 8.0))
	if page >= total_pages:
		page = total_pages - 1
	populate_page()

func _on_exit_button_pressed() -> void:
	hide()

func _on_next_button_pressed() -> void:
	page += 1
	populate_page()

func _on_previous_button_pressed() -> void:
	page -= 1
	populate_page()
