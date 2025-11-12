extends MarginContainer

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $LetterDisplayTimer
@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
@onready var margin_container: MarginContainer = $MarginContainer
@onready var textbox: MarginContainer = $"."

const MAX_WIDTH = 256

var text = ""
var letter_index = 0
var speaker_name

var letter_time = 0.03
var space_time = 0.06
var punc_time = 0.2

var voice : String = "voice_letter"

signal finished_displaying

func display_text(text_to_display : String, speaker_name_func : String):
	speaker_name = speaker_name_func
	nine_patch_rect.visible = true
	set_margin(15, 15, 15, 45)
	
	text = text_to_display
	_display_letter()

func _display_letter():
	label.text = text
	label.visible_characters = letter_index + 1
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	match speaker_name:
		"L":
			voice = "voice_letter_l"
		_:
			voice = "voice_letter"
	
	match text[letter_index]:
		"!", ".", ",", "?", "…":
			timer.start(punc_time)
			voice = "none"
		" ":
			timer.start(space_time)
			voice = "none"
		_:
			timer.start(letter_time)

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
	Audio.play_sfx(voice)

func set_margin(top : int, bottom : int, left : int, right : int):
	margin_container.add_theme_constant_override("margin_top", top)
	margin_container.add_theme_constant_override("margin_bottom", bottom)
	margin_container.add_theme_constant_override("margin_left", left)
	margin_container.add_theme_constant_override("margin_right", right)

func _unhandled_input(event) -> void:
	if (
		event.is_action_pressed("advance_dialog")
	):
		letter_index = text.length()
