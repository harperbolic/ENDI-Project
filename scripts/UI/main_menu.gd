extends Control

# Main Menu buttons
@onready var buttons: HBoxContainer = $Buttons
@onready var start_game: Button = $Buttons/StartGame
@onready var start_game_2: Button = $Buttons/StartGame2
@onready var options: Button = $Buttons/Options
@onready var credits: Button = $Buttons/Credits
@onready var quit_game: Button = $Buttons/QuitGame

#labels
@onready var game_title: Label = $GameTitle
@onready var game_logo: TextureRect = $GameLogo
@onready var options_label: Label = $Options/Label
@onready var sfx: Label = $Options/VBoxContainer/HBoxContainer/sfx
@onready var mus: Label = $Options/VBoxContainer/HBoxContainer2/mus
@onready var language: Label = $Options/VBoxContainer/HBoxContainer3/language
@onready var fullscreen: Label = $Options/VBoxContainer/HBoxContainer4/fullscreen

# Options Buttons
@onready var options_panel = $Options
@onready var back: Button = $Options/Back/Back
@onready var sfx_control: HSlider = $Options/VBoxContainer/HBoxContainer/SFXControl
@onready var music_control: HSlider = $Options/VBoxContainer/HBoxContainer2/MusicControl
@onready var language_button: OptionButton = $Options/VBoxContainer/HBoxContainer3/OptionButton
@onready var fullscreen_toggle: CheckButton = $Options/VBoxContainer/HBoxContainer4/FullscreenToggle

# Music Mixers
var sfx_bus : int
var mus_bus : int

# Animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	AUDIO.stop_all_music()
	
	# Hide options panel
	options_panel.visible = false
	
	# Get audio save
	sfx_control.value = DEF.settings_save["sfx_volume"]
	music_control.value = DEF.settings_save["mus_volume"]
	
	# Get fullscreen save
	if DEF.settings_save["fullscreen"]:
		fullscreen_toggle.button_pressed = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		fullscreen_toggle.button_pressed = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	# Get buses
	sfx_bus = AudioServer.get_bus_index("SFX")
	mus_bus = AudioServer.get_bus_index("Music")
	
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(DEF.settings_save["sfx_volume"]))
	AudioServer.set_bus_volume_db(mus_bus, linear_to_db(DEF.settings_save["mus_volume"]))
	
	AUDIO.play_music("menu_theme")
	
	if FileAccess.file_exists(DEF.SAVE_PATH):
		start_game_2.disabled = false
	
	match DEF.selected_language:
		"en":
			language_button.selected = 0
		"pt":
			language_button.selected = 1
		_:
			language_button.selected = 0
	
	#localize button names
	update_text()

func _on_start_game_pressed() -> void:
	AUDIO.play_sfx("click")
	AUDIO.stop_music("menu_theme")
	
	animation_player.play("screen_fade")
	
	await animation_player.animation_finished
	
	SCENE.load_scene("stage0")

func _on_start_game_2_pressed() -> void:
		AUDIO.play_sfx("click")
		AUDIO.stop_music("menu_theme")
		
		animation_player.play("screen_fade")
		
		await animation_player.animation_finished
		var level : int = DEF.save.get("level")
		SCENE.load_scene("stage" + str(level))


func _on_options_pressed() -> void:
	game_logo.visible = false
	options_panel.visible = true
	buttons.visible = false
	AUDIO.play_sfx("click")

func _on_credits_pressed() -> void:
	SCENE.load_scene("credits")
	AUDIO.play_sfx("click")

func _on_quit_game_pressed() -> void:
	AUDIO.play_sfx("click")
	AUDIO.stop_all_music()
	await AUDIO.sfx_finished
	get_tree().quit()

func _on_back_pressed() -> void:
	buttons.visible = true
	game_logo.visible = true
	options_panel.visible = false
	AUDIO.play_sfx("click")
	save_settings()

func save_settings() -> void:
	var access = FileAccess.open(DEF.CONFIG_PATH, FileAccess.WRITE)
	access.store_string(JSON.stringify(DEF.settings_save))
	access.close()

func _on_sfx_control_value_changed(value: float) -> void:
	DEF.settings_save["sfx_volume"] = value
	value = linear_to_db(value)
	AudioServer.set_bus_volume_db(sfx_bus, value)

func _on_music_control_value_changed(value: float) -> void:
	DEF.settings_save["mus_volume"] = value
	value = linear_to_db(value)
	AudioServer.set_bus_volume_db(mus_bus, value)

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	DEF.settings_save["fullscreen"] = toggled_on

func update_text():
	game_title.text = DEF.UI_text.get("game_title")
	start_game.text = DEF.UI_text.get("new_game")
	start_game_2.text = DEF.UI_text.get("continue")
	options_label.text = DEF.UI_text.get("options")
	credits.text = DEF.UI_text.get("credits")
	quit_game.text = DEF.UI_text.get("quit_game")
	sfx.text = DEF.UI_text.get("sfx")
	mus.text = DEF.UI_text.get("music")
	language.text = DEF.UI_text.get("language")
	fullscreen.text = DEF.UI_text.get("fullscreen")
	back.text = DEF.UI_text.get("back")

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DEF.selected_language = "en"
			DEF.settings_save["language"] = "en"
		1:
			DEF.selected_language = "pt"
			DEF.settings_save["language"] = "pt"
	DEF.load_locale()
	update_text()
