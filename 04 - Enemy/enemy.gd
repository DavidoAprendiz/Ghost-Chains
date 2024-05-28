extends CharacterBody2D

const SPEED : float = 0.69 * 1.69 # 0.69 * 6.9 / 4.20

# Enemy movement
func _physics_process(_delta):
	var direction : Vector2 = (get_node("/root/Main/Player").position - position).normalized()
	position += direction * SPEED
	move_and_slide()

# Enemy random position
func call_enemy():
	var chance : int = randi_range(1,4)
	match chance:
		#enemy.set_position(Vector2(randf_range(0, 1920), randf_range(0, 1080))) # full screen
		1: set_position(Vector2(randf_range(20, 1900), randf_range(20, 0))) # upper screen
		2: set_position(Vector2(randf_range(20, 1900), randf_range(1060, 1060))) # down screen
		3: set_position(Vector2(randf_range(20, 20), randf_range(20, 1060))) # left screen
		4: set_position(Vector2(randf_range(1900, 1900), randf_range(20, 1060))) # right screen

# Clean objects
func _on_visible_on_screen_notifier_2d_screen_exited():
	self.queue_free()

# Clean objects
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Bullet"):
		$EnemySound.play()
		$EnemySprite.play("death")
		await $EnemySprite.animation_finished
		self.queue_free()
