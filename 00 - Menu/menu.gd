extends Control

var view_settings : bool = false
var is_night_mode : bool = true
var is_sound_on : bool = true
var is_music_on : bool = true

# Prepare "first run"
func _ready():
	show_settings_menu()
	change_theme()
	check_system_OS()
	
# Change the button layouts
func check_system_OS():
	if OS.has_feature("web"):
		$Buttons/AdaGhost.text = "Play as CARDANO"
		$Buttons/ErgGhost.text = "Play as ERGO"
		$Buttons/GiveUpFinal.text = "Goodbye Ghost!"
		$Buttons/GiveUp.visible = false
	elif OS.has_feature("32") or OS.has_feature("64"):
		$Buttons/AdaGhost.text = "Play as C₳RD₳NO \n 👻"
		$Buttons/ErgGhost.text = "Play as ΣRGO \n 👻"
		$Buttons/GiveUpFinal.text = "Goodbye Ghost! \n 👻👻👻"

# Define theme (button)
func _on_night_mode_pressed():
	if is_sound_on:
		$MenuSound.play()
	is_night_mode = !is_night_mode
	change_theme()

# Play as Cardano
func _on_ada_ghost_pressed():
	get_parent().bullet_type = "Ada"
	get_parent().get_node("Player").is_sound_on = is_sound_on
	get_parent().choice("Ada")
	self.queue_free()

# Play as Ergo
func _on_erg_ghost_pressed():
	get_parent().bullet_type = "Erg"
	get_parent().get_node("Player").is_sound_on = is_sound_on
	get_parent().choice("Erg")
	self.queue_free()

# Exit buttons
func _on_give_up_pressed():
	$Buttons/GiveUp.visible = false
	$Buttons/GiveUpFinal.visible = true
func _on_give_up_2_pressed():
	get_tree().quit()

# Open/Close menu window
func show_settings_menu():
	var nodes = get_node("Settings").get_children()
	match view_settings:
		true:
			for node in nodes:
				node.visible = true
		false:
			for node in nodes:
				node.visible = false
	view_settings = !view_settings

# Define theme
func change_theme():
	var nodes = ["Score", "HighScore", "Health", "Player/Final/FinalScore"]
	change_sound_layout()
	match is_night_mode:
		false:
			$TextureRect.texture = preload("res://06 - Configuration/background.png")
			$TextureRect/Cardano.set("theme_override_colors/font_color", Color.BLACK)
			$TextureRect/Ergo.set("theme_override_colors/font_color", Color.BLACK)
			$Settings/SettingsFiled/NightMode.icon = preload("res://06 - Configuration/day.png")
			get_parent().get_node("TextureRect2").texture = preload("res://06 - Configuration/background.png")
			for node in nodes:
				get_parent().get_node(node).add_theme_color_override("default_color", Color.BLACK)
		true:
			$TextureRect.texture = load("res://06 - Configuration/background_night.png")
			$TextureRect/Cardano.set("theme_override_colors/font_color", Color.GHOST_WHITE)
			$TextureRect/Ergo.set("theme_override_colors/font_color", Color.GHOST_WHITE)
			$Settings/SettingsFiled/NightMode.icon = preload("res://06 - Configuration/night.png")
			$Settings/SettingsFiled/Github.icon = preload("res://06 - Configuration/github-white.png")
			$Settings/SettingsFiled/X.icon = preload("res://06 - Configuration/x-white.png")
			$Settings/SettingsFiled/ItchIo.icon = preload("res://06 - Configuration/itchio-white.png")
			get_parent().get_node("TextureRect2").texture = preload("res://06 - Configuration/background_night.png")
			for node in nodes:
				get_parent().get_node(node).add_theme_color_override("default_color", Color.GHOST_WHITE)

# Sound/Music Icons
func change_sound_layout():
	match is_night_mode:
		true:
			match is_sound_on:
				true: $Settings/SettingsFiled/SoundButton.icon = load("res://06 - Configuration/speaker_white_on.png")
				false: $Settings/SettingsFiled/SoundButton.icon = load("res://06 - Configuration/speaker_white_off.png")
			match is_music_on:
				true: $Settings/SettingsFiled/MusicButton.icon = load("res://06 - Configuration/music_on_white.png")
				false: $Settings/SettingsFiled/MusicButton.icon = load("res://06 - Configuration/music_off_white.png")
		false:
			match is_sound_on:
				true: $Settings/SettingsFiled/SoundButton.icon = load("res://06 - Configuration/speaker_dark_on.png")
				false: $Settings/SettingsFiled/SoundButton.icon = load("res://06 - Configuration/speaker_dark_off.png")
			match is_music_on:
				true: $Settings/SettingsFiled/MusicButton.icon = load("res://06 - Configuration/music_on_dark.png")
				false: $Settings/SettingsFiled/MusicButton.icon = load("res://06 - Configuration/music_off_dark.png")

# Sounds notifications
func _on_ada_ghost_mouse_entered():
	if is_sound_on:
		$MenuSound.play()
func _on_erg_ghost_mouse_entered():
	if is_sound_on:
		$MenuSound.play()
func _on_give_up_mouse_entered():
	if is_sound_on:
		$MenuSound.play()
func _on_give_up_2_mouse_entered():
	if is_sound_on:
		$MenuSound.play()

func _on_sound_button_pressed():
	match is_sound_on:
			true: $MenuSound.stop()
			false: $MenuSound.play()
	is_sound_on = !is_sound_on
	change_sound_layout()

func _on_music_button_pressed():
	if is_sound_on:
		$MenuSound.play()
	match is_music_on:
			true: get_parent().get_node("BgMusic").stop()
			false: get_parent().get_node("BgMusic").play()
	is_music_on = !is_music_on
	change_sound_layout()

# Open/Close menu window (button)
func _on_settings_pressed():
	if is_sound_on:
		$MenuSound.play()
	show_settings_menu()

# Github/X links
func _on_github_pressed():
	if is_sound_on:
		$MenuSound.play()
	OS.shell_open("https://github.com/DavidoAprendiz")
func _on_x_pressed():
	if is_sound_on:
		$MenuSound.play()
	OS.shell_open("https://x.com/David_oAprendiz")
func _on_itch_io_pressed():
	if is_sound_on:
		$MenuSound.play()
	OS.shell_open("https://davidoaprendiz.itch.io")

# Get prices 
func get_ergo_price():
	var coingecko = "https://api.coingecko.com/api/v3/simple/price?ids=ergo&vs_currencies=eur"
	var teste = $ErgPrice/Erg.request(coingecko)
	if teste != OK:
		$ErgPrice.text = "[center][color=ff5e00] Price N/A"

func get_cardano_price():
	var coingecko = "https://api.coingecko.com/api/v3/simple/price?ids=cardano&vs_currencies=eur"
	var teste = $AdaPrice/Ada.request(coingecko)
	if teste != OK:
		$AdaPrice.text = "[center][color=ff5e00] Price N/A"

func _on_erg_request_completed(_result, _response_code, _headers, body):
	var data = JSON.new()
	var check_error = data.parse(body.get_string_from_utf8())
	if check_error == OK:
		var resposta = data.get_data()["ergo"]["eur"]
		$ErgPrice.text = "[center][color=ff5e00]" + str("%.2f" % resposta) + " €"
	else:
		$ErgPrice.text = "[center][color=ff5e00] Price N/A"

func _on_ada_request_completed(_result, _response_code, _headers, body):
	var data = JSON.new()
	var check_error = data.parse(body.get_string_from_utf8())
	if check_error == OK:
		var resposta = data.get_data()["cardano"]["eur"]
		$AdaPrice.text = "[center][color=ff5e00] " + str("%.2f" % resposta) + " €"
	else:
		$AdaPrice.text = "[center][color=ff5e00] Price N/A"

func _on_update_price_pressed():
	get_cardano_price()
	get_ergo_price()
