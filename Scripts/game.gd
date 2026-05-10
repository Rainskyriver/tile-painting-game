extends Node

@onready var win_check : int = 0
@onready var colors : Array = [
	load("res://Resources/color.tres"),
	load("res://Resources/color1.tres"),
	load("res://Resources/color2.tres"),
	load("res://Resources/color3.tres"),
	load("res://Resources/color4.tres"),
	load("res://Resources/color5.tres")
]
@onready var painting_mode : bool = true

@onready var current_color : BaseMaterial3D
func set_color(color: BaseMaterial3D):
	current_color = color
