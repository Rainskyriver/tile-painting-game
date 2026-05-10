extends Control

@onready var grid : GridContainer = get_node("Single Grid")
@onready var grid_children = grid.get_children()
var stage : int = 0

func set_colors(colors : Array):
	for i in range(grid_children.size()):
		grid_children[i].color = colors[i]

func rotate():
	stage += 1
	rotation_degrees += 90
	if stage == 4:
		stage = 0
	if stage == 0:
		Game.win_check += 1
	if stage == 1:
		Game.win_check -= 1

	print(Game.win_check)
func _on_button_pressed() -> void:
	rotate()
