extends Control

var view_settings : bool = false
var is_night_mode : bool = true
var is_sound_on : bool = true
var is_music_on : bool = true

# Prepare "first run"
func _ready() -> void:
	show_settings_menu()
	change_theme()
	check_system_OS()
	
# Change the button layouts
func check_system_OS() -> void:
	if OS.has_feature("web"):
		($Buttons/AdaGhost as Button).text = "Play as CARDANO"
		($Buttons/ErgGhost as Button).text = "Play as ERGO"
		($Buttons/GiveUpFinal as Button).text = "Goodbye Ghost!"
		($Buttons/GiveUp as Button).visible = false
	elif OS.has_feature("32") or OS.has_feature("64"):
		($Buttons/AdaGhost as Button).text = "Play as C₳RD₳NO \n 👻"
		($Buttons/ErgGhost as Button).text = "Play as ΣRGO \n 👻"
		($Buttons/GiveUpFinal as Button).text = "Goodbye Ghost! \n 👻👻👻"

# Define theme (button)
func _on_night_mode_pressed() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
	is_night_mode = !is_night_mode
	change_theme()

# Play as Cardano
func _on_ada_ghost_pressed() -> void:
	get_parent().bullet_type = "Ada"
	get_parent().get_node("Player").is_sound_on = is_sound_on
	get_parent().choice("Ada")
	self.queue_free()

# Play as Ergo
func _on_erg_ghost_pressed() -> void:
	get_parent().bullet_type = "Erg"
	get_parent().get_node("Player").is_sound_on = is_sound_on
	get_parent().choice("Erg")
	self.queue_free()

# Exit buttons
func _on_give_up_pressed() -> void:
	($Buttons/GiveUp as Button).visible = false
	($Buttons/GiveUpFinal as Button).visible = true
func _on_give_up_2_pressed() -> void:
	get_tree().quit()

# Open/Close menu window
func show_settings_menu() -> void:
	var nodes : Array[Node] = get_node("Settings").get_children()
	match view_settings:
		true:
			for node : Node in nodes:
				node.visible = true
		false:
			for node : Node in nodes:
				node.visible = false
	view_settings = !view_settings

# Define theme
func change_theme() -> void:
	var nodes : Array[String] = ["Score", "HighScore", "Health", "Player/Final/FinalScore"]
	change_sound_layout()
	match is_night_mode:
		false:
			($TextureRect as TextureRect).texture = preload("res://06 - Configuration/background.png")
			($TextureRect/Cardano as LinkButton).set("theme_override_colors/font_color", Color.BLACK)
			($TextureRect/Ergo as LinkButton).set("theme_override_colors/font_color", Color.BLACK)
			($Settings/SettingsFiled/NightMode as CheckButton).icon = preload("res://06 - Configuration/day.png")
			(get_parent().get_node("TextureRect2") as TextureRect).texture = preload("res://06 - Configuration/background.png")
			for node : String in nodes:
				(get_parent().get_node(node) as Node).add_theme_color_override("default_color", Color.BLACK)
		true:
			($TextureRect as TextureRect).texture = load("res://06 - Configuration/background_night.png")
			($TextureRect/Cardano as LinkButton).set("theme_override_colors/font_color", Color.GHOST_WHITE)
			($TextureRect/Ergo as LinkButton).set("theme_override_colors/font_color", Color.GHOST_WHITE)
			($Settings/SettingsFiled/NightMode as CheckButton).icon = preload("res://06 - Configuration/night.png")
			($Settings/SettingsFiled/Github as Button).icon = preload("res://06 - Configuration/github-white.png")
			($Settings/SettingsFiled/X as Button).icon = preload("res://06 - Configuration/x-white.png")
			($Settings/SettingsFiled/ItchIo as Button).icon = preload("res://06 - Configuration/itchio-white.png")
			(get_parent().get_node("TextureRect2") as TextureRect).texture = preload("res://06 - Configuration/background_night.png")
			for node : String in nodes:
				(get_parent().get_node(node) as Node).add_theme_color_override("default_color", Color.GHOST_WHITE)

# Sound/Music Icons
func change_sound_layout() -> void:
	match is_night_mode:
		true:
			match is_sound_on:
				true: ($Settings/SettingsFiled/SoundButton as Button).icon = load("res://06 - Configuration/speaker_white_on.png")
				false: ($Settings/SettingsFiled/SoundButton as Button).icon = load("res://06 - Configuration/speaker_white_off.png")
			match is_music_on:
				true: ($Settings/SettingsFiled/MusicButton as Button).icon = load("res://06 - Configuration/music_on_white.png")
				false: ($Settings/SettingsFiled/MusicButton as Button).icon = load("res://06 - Configuration/music_off_white.png")
		false:
			match is_sound_on:
				true: ($Settings/SettingsFiled/SoundButton as Button).icon = load("res://06 - Configuration/speaker_dark_on.png")
				false: ($Settings/SettingsFiled/SoundButton as Button).icon = load("res://06 - Configuration/speaker_dark_off.png")
			match is_music_on:
				true: ($Settings/SettingsFiled/MusicButton as Button).icon = load("res://06 - Configuration/music_on_dark.png")
				false: ($Settings/SettingsFiled/MusicButton as Button).icon = load("res://06 - Configuration/music_off_dark.png")

# Sounds notifications
func _on_ada_ghost_mouse_entered() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
func _on_erg_ghost_mouse_entered() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
func _on_give_up_mouse_entered() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
func _on_give_up_2_mouse_entered() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()

func _on_sound_button_pressed() -> void:
	match is_sound_on:
			true: ($MenuSound as AudioStreamPlayer).stop()
			false: ($MenuSound as AudioStreamPlayer).play()
	is_sound_on = !is_sound_on
	change_sound_layout()

func _on_music_button_pressed() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
	match is_music_on:
			true: (get_parent().get_node("BgMusic") as AudioStreamPlayer).stop()
			false: (get_parent().get_node("BgMusic") as AudioStreamPlayer).play()
	is_music_on = !is_music_on
	change_sound_layout()

# Open/Close menu window (button)
func _on_settings_pressed() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
	show_settings_menu()

# Github/X links
func _on_github_pressed() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
	OS.shell_open("https://github.com/DavidoAprendiz")
func _on_x_pressed() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
	OS.shell_open("https://x.com/David_oAprendiz")
func _on_itch_io_pressed() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
	OS.shell_open("https://davidoaprendiz.itch.io")

# Get prices 
func get_ergo_price() -> void:
	var coingecko : String = "https://api.coingecko.com/api/v3/simple/price?ids=ergo&vs_currencies=eur"
	var test_request : Error = ($ErgPrice/Erg as HTTPRequest).request(coingecko)
	if test_request != OK:
		($ErgPrice as RichTextLabel).text = "[center][color=ff5e00] Price N/A"

func get_cardano_price() -> void:
	var coingecko : String = "https://api.coingecko.com/api/v3/simple/price?ids=cardano&vs_currencies=eur"
	var test_request : Error = ($AdaPrice/Ada as HTTPRequest).request(coingecko)
	if test_request != OK:
		($AdaPrice as RichTextLabel).text = "[center][color=ff5e00] Price N/A"

func _on_erg_request_completed(_result, _response_code, _headers, body) -> void:
	var data : JSON = JSON.new()
	var check_error : Error = data.parse(body.get_string_from_utf8())
	if check_error == OK:
		var resposta : float = data.get_data()["ergo"]["eur"]
		($ErgPrice as RichTextLabel).text = "[center][color=ff5e00]" + str("%.2f" % resposta) + " €"
	else:
		($ErgPrice as RichTextLabel).text = "[center][color=ff5e00] Price N/A"

func _on_ada_request_completed(_result, _response_code, _headers, body) -> void:
	var data : JSON = JSON.new()
	var check_error : Error = data.parse(body.get_string_from_utf8())
	if check_error == OK:
		var resposta : float = data.get_data()["cardano"]["eur"]
		($AdaPrice as RichTextLabel).text = "[center][color=ff5e00] " + str("%.2f" % resposta) + " €"
	else:
		($AdaPrice as RichTextLabel).text = "[center][color=ff5e00] Price N/A"

func _on_update_price_pressed() -> void:
	get_cardano_price()
	get_ergo_price()

func _on_update_price_mouse_entered() -> void:
	if is_sound_on:
		($MenuSound as AudioStreamPlayer).play()
