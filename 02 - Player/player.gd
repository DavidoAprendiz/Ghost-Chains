extends CharacterBody2D

# Scenes
const BULLET : PackedScene = preload("res://03 - Bullet/bullet.tscn")
# Labels from Main
@onready var health_label_path = get_node("../Health")
@onready var score_label_path : Node = get_node("../Score")
@onready var high_score_label_path : Node = get_node("../HighScore")
@onready var main_camera = get_node("../Camera")
# Player configuration
var bullet_type : String
var can_shoot : bool = false
var can_look : bool = true
var counter : int = 0 # to change sprites/bullets
var health : int = 3
var score : int = 0
var high_score : int = 0
var speed : float = 4.20
var is_sound_on : bool

# Controls player movement
func _physics_process(_delta):
	var vel : Vector2 = Vector2(get_global_mouse_position() - global_position)
	velocity = vel * speed
	move_and_slide()

func _process(_delta):
	# Exit the game (during the game or in the Menu)
	if Input.is_action_just_pressed("sair"):
		if bullet_type:
			health = 0
			confirm_death()
		elif OS.has_feature("32") or OS.has_feature("64"):
				get_tree().quit()
	# Controls player rotation. If false (death), updates player position, zoom and speed
	if can_look:
		look_at(get_global_mouse_position())
	elif main_camera.zoom < Vector2(2,2):
		main_camera.zoom += Vector2(0.00420,0.00420)
		position = Vector2(960,340)
		speed = 0.07
	# Checks user input and fires/shoots
	if Input.is_action_just_pressed("disparar") and can_shoot:
		to_shoot()

# Create instances of bullets according to the user's choice and fires/shoots
func to_shoot():
	var bullet : CharacterBody2D = BULLET.instantiate()
	bullet.bullet_type = bullet_type
	match bullet_type:
		"Erg":
			var erg_sprite : Array = bullet.get_erg_sprites()
			var project = bullet.get_node(bullet_type + "/"  + str(erg_sprite[counter]))
			project.visible = true
			if (counter >= erg_sprite.size()-1):
				counter = 0
			else:
				counter += 1
		"Ada":
			var ada_sprite : Array = bullet.get_ada_sprites()
			var project : Node = bullet.get_node(bullet_type + "/"  + str(ada_sprite[counter]))
			project.visible = true
			if (counter >= ada_sprite.size()-1):
				counter = 0
			else:
				counter += 1
	bullet.transform = $BulletArea/BulletMarker.global_transform
	$BulletSound.play()
	get_parent().add_child(bullet)

# Update health
func update_health(gain_health):
	if health >= 1:
		if gain_health:
			health += 1
		else:
			health -= 1
			if health == 0:
				confirm_death()
	else:
		confirm_death()
	update_labels(health,score,high_score)

# Update score and high score
func update_score():
	score += 1
	if score > high_score:
		high_score = score
	update_labels(health,score,high_score)

# Update Health/Score/High Score labels
func update_labels(healths, scores, highscores):
	health_label_path.text = " " + str(healths) +  " Hearth/s"
	score_label_path.text = " Bitcoin Cycle/s: " + str("%.6f" % [scores/(365*4+1.0)]) + "\n CBDC's infected: " + str(scores) + " "
	high_score_label_path.text = "[right]" + "HIGH SCORE \n(1 cycle = 4 years) \n" + str(high_score) + " infected \n" + str("%.6f" % [highscores/(365*4+1.0)]) + " Bitcoin cycle(s)"

# Confirm the player's death :)
func confirm_death():
	get_parent().get_node("EnemyTimer").stop()
	get_parent().get_node("PowerUpTimer").stop()
	can_shoot = false
	can_look = false
	$Final.visible = true
	if OS.has_feature("web"):
		$Final/Exit.visible = false
	$Final.global_rotation = 0.0
	$Final/FinalScore.text = "[left] CURRENT SCORE \n" + score_label_path.text + "[/left]\n\n" + high_score_label_path.text
	get_node(bullet_type).global_rotation = 0.0
	get_node(bullet_type).play("death")
	await get_node(bullet_type).animation_finished

# Reset player settings and timers
func player_retry():
	main_camera.zoom = Vector2(1,1)
	$Final.visible = false
	can_shoot = true
	can_look = true
	score = 0
	health = 3
	speed = 4.20
	get_parent().time_min = 0.5
	get_parent().time_max = get_parent().time_max - 0.1
	get_node(bullet_type).frame = 0
	get_node(bullet_type).rotation = 0.0
	get_parent().choice(bullet_type)

# Check enemy contact and update health, stop update after life <= 0
func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		update_health(false)
		if health > 0:
			get_node(bullet_type).play("hit")
			await get_node(bullet_type).animation_finished
			get_node(bullet_type).animation = "death"
			get_node(bullet_type).frame = 0

# Open the Menu ( _ready() will load initial values ) (button)
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://01 - Main/main.tscn")

# Close the game (button)
func _on_exit_pressed():
	if OS.has_feature("32") or OS.has_feature("64"):
		get_tree().quit()
	else:
		$Final/Exit.disabled = true

# Starts again with the same settings chosen by the user (button)
func _on_retry_pressed():
	player_retry()

# Sounds
func play_menu_sound():
	if is_sound_on:
		$MenuSound.play()
func _on_menu_mouse_entered():
	play_menu_sound()
func _on_exit_mouse_entered():
	play_menu_sound()
func _on_retry_mouse_entered():
	play_menu_sound()

# Spin player (button)
func _on_animation_pressed():
	get_node(bullet_type).play("death")
	await get_node(bullet_type).animation_finished
