extends Node

@onready var text_box_scene = preload("res://scenes/game_elements/textbox.tscn")
@onready var dialog_container = preload("res://scenes/game_elements/dialog_container.tscn")
@onready var portrait_container = preload("res://scenes/game_elements/portraits.tscn")

var dialog_lines : Dictionary = {}
var current_line_index = 0

var text_box
var container
var portraits
var current_client

var is_dialog_active = false
var can_advance_line = false

var boxes : Array = [null, null, null, null, null]

signal dialog_ended

func start_dialog(lines: Dictionary):
	if is_dialog_active:
		return
	
	dialog_lines =  lines
	_show_portraits()
	_show_container()
	_show_text_box()
	
	is_dialog_active = true

func _show_portraits():
	portraits = portrait_container.instantiate()
	get_tree().root.add_child(portraits)
	portraits.bg_fade_in()

func _show_container():
	container = dialog_container.instantiate()
	get_tree().root.add_child(container)

func _show_text_box():
	text_box = text_box_scene.instantiate()
	
	clear_boxes()
	boxes[0] = text_box
	
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	container.add_child(text_box)
	text_box.display_text(dialog_lines[str(current_line_index)].text, dialog_lines[str(current_line_index)].name)
	can_advance_line = false
	
	portraits.change_portrait(dialog_lines[str(current_line_index)].name, dialog_lines[str(current_line_index)].expression)

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event) -> void:
	if (
		event.is_action_pressed("Confirm") && 
		is_dialog_active &&
		can_advance_line
	):
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			container.queue_free()
			if boxes[2] != null:
				boxes[2].queue_free()
			if boxes[1] != null:
				boxes[1].queue_free()
			boxes[0].queue_free()
			portraits.fade_out()
			portraits.queue_free()
			is_dialog_active = false
			current_line_index = 0
			dialog_ended.emit()
			return
		
		_show_text_box()

func clear_boxes():
	if boxes[2] != null:
		boxes[2].queue_free()
	boxes[2] = boxes[1]
	boxes[1] = boxes[0]

func reset_boxes():
	if boxes[2] != null:
		boxes[2].queue_free()
	if boxes[1] != null:
		boxes[1].queue_free()
