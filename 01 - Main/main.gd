extends Node2D

# Scenes
const MENU_PATH : PackedScene = preload("res://00 - Menu/menu.tscn")
const ENEMY_PATH : PackedScene = preload("res://04 - Enemy/enemy.tscn")
const POWERUP_PATH : PackedScene = preload("res://05 - PowerUps/powerups.tscn")
const BITCOIN_PATH : PackedScene = preload("res://05 - PowerUps/bitcoin.tscn")
# Enemy Timers
var time_min : float = 0.5
var time_max : float = 2.0
# Power up Timers
var power_time_min : int = 7
var power_time_max : int = 15
# User choice from Menu
var bullet_type : String 

func _ready() -> void:
	open_menu()

# Open menu
func open_menu() -> void:
	var menu : Control = MENU_PATH.instantiate()
	add_child(menu)

# Define player icon and the bullets |  Start of the game
func choice(bullet_types) -> void:
	get_node("Player/" + bullet_types).visible = true
	$Player.bullet_type = bullet_types
	$EnemyTimer.start()
	$DiffTimer.start()
	$BitcoinTimer.start()
	$PowerUpTimer.wait_time = randi_range(power_time_min,power_time_max)
	$PowerUpTimer.start()
	$Player.can_shoot = true
	$Player.update_labels($Player.health,$Player.score,$Player.high_score)

# Create instances of enemies
func create_enemy() -> void:
	var enemy : CharacterBody2D = ENEMY_PATH.instantiate()
	enemy.call_enemy()
	add_child(enemy)

# Create instances of powerups
func power_up() -> void:
	var power : CharacterBody2D = POWERUP_PATH.instantiate()
	power.call_powerup()
	add_child(power)

# Create instances of powerups (timer)
func _on_power_up_timer_timeout() -> void:
	if get_node("EnemyTimer").is_stopped:
		get_node("EnemyTimer").start()
	$PowerUpTimer.wait_time = randi_range(power_time_min,power_time_max)
	power_up()

# Create instances of enemies (timer)
func _on_enemy_timer_timeout() -> void:
	$EnemyTimer.wait_time = randf_range(time_min, time_max)
	create_enemy()

# Increases the difficulty of the game(timer)
func _on_diff_timer_timeout() -> void:
	if time_max > time_min:
		time_max -= 0.1
	else:
		time_max -= 0.01
		time_min = time_max

# Create direct instances of Bitcoin (timer)
func _on_bitcoin_timer_timeout() -> void:
	var btc : Node = BITCOIN_PATH.instantiate()
	btc.set_position(Vector2(randf_range(80, 1840), randf_range(80, 1000)))
	$BitcoinTimer.wait_time = $BitcoinTimer.wait_time - 1
	add_child(btc)
