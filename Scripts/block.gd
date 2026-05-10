extends Area3D

@onready var upper_left = get_node("UpperLeft")
@onready var middle_left = get_node("MiddleLeft")
@onready var middle_right = get_node("MiddleRight")
@onready var middle = get_node("Middle")
@onready var lower_right = get_node("LowerRight")
@onready var main_collision = get_node("CollisionShape3D")
@onready var white = load("res://Resources/color5.tres")
var selected: bool = false
@onready var color = Game.colors
var section : int
func _ready() -> void:
	set_colors([white,white,white,white,white])
	Game.set_color(Game.colors[0])
func set_colors(a):
	upper_left.set_surface_override_material(0, a[0])
	middle_left.set_surface_override_material(0, a[1])
	middle_right.set_surface_override_material(0, a[2])
	middle.set_surface_override_material(0, a[3])
	lower_right.set_surface_override_material(0, a[4])	
	
func cycle_colors():
	var upper_left_material : BaseMaterial3D = upper_left.get_surface_override_material(0)
	upper_left.set_surface_override_material(0,middle_right.get_surface_override_material(0))
	middle_right.set_surface_override_material(0,middle.get_surface_override_material(0))	
	middle.set_surface_override_material(0,middle_left.get_surface_override_material(0))
	middle_left.set_surface_override_material(0,lower_right.get_surface_override_material(0))
	lower_right.set_surface_override_material(0,upper_left_material)	
	

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	check_if_click(event, lower_right)
func _on_area_3d_2_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	check_if_click(event, upper_left)
func _on_area_3d_3_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	check_if_click(event, middle_left)
func _on_area_3d_4_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	check_if_click(event, middle_right)
func _on_area_3d_5_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	check_if_click(event, middle)
func get_color_indices() -> Array:
	var sections = [upper_left, middle_left, middle_right, middle, lower_right]
	var indices : Array = []
	for s in sections:
		indices.append(Game.colors.find(s.get_surface_override_material(0)))
	return indices

func set_colors_by_index(indices : Array):
	upper_left.set_surface_override_material(0, Game.colors[indices[0]])
	middle_left.set_surface_override_material(0, Game.colors[indices[1]])
	middle_right.set_surface_override_material(0, Game.colors[indices[2]])
	middle.set_surface_override_material(0, Game.colors[indices[3]])
	lower_right.set_surface_override_material(0, Game.colors[indices[4]])

func check_if_click(event: InputEvent, section : MeshInstance3D):
	if event.is_action_pressed("click"):
		if Game.painting_mode == true:
			section.set_surface_override_material(0, Game.current_color)
		else:
			rotate(Vector3(0,1,0),1.570796)
