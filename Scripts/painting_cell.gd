extends HBoxContainer

@onready var load_button = get_node("Background/Load/LoadButton")
@onready var delete_button = get_node("Background/Delete/DeleteButton")
@onready var background : ColorRect = get_node("Background")
@onready var label : Label = get_node("Background/Label")
@onready var confirm = get_node("Background/Confirm")

signal load_requested(index : int)
signal delete_requested(index : int)

var painting_index : int = -1

func _ready() -> void:
	confirm.hide()
	load_button.disabled = true
	delete_button.disabled = true

func load_data(painting : PaintingData, index : int):
	painting_index = index
	label.text = painting.painting_name
	background.color = get_most_common_color(painting)
	load_button.disabled = false
	delete_button.disabled = false

func get_most_common_color(painting : PaintingData) -> Color:
	var counts : Array = [0, 0, 0, 0, 0, 0]
	for block in painting.block_colors:
		for idx in block:
			if idx >= 0:
				counts[idx] += 1
	var max_idx : int = 0
	for i in range(counts.size()):
		if counts[i] > counts[max_idx]:
			max_idx = i
	return Game.colors[max_idx].albedo_color

func _on_load_button_pressed() -> void:
	load_requested.emit(painting_index)

func _on_delete_button_pressed() -> void:
	confirm.show()

func _on_yes_pressed() -> void:
	delete_requested.emit(painting_index)

func _on_no_pressed() -> void:
	confirm.hide()
