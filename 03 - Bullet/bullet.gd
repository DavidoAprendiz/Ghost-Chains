extends CharacterBody2D

# Type of bullets chosen by the user (from Player)
var bullet_type : String
const SPEED : float = 69.69 * 69.69

# Bullet movement and rotation
func _physics_process(delta) -> void:
	position += (transform.x * SPEED * delta)
	match bullet_type:
		"Erg":
			for project : Node in get_erg_sprites():
				if project.visible:
					project.rotate(0.01)
		"Ada":
			for project : Node in get_ada_sprites():
				if project.visible:
					project.rotate(0.01)

# Types of bullets
func get_ada_sprites() -> Array[Node]:
	return get_node("Ada").get_children()
func get_erg_sprites() -> Array[Node]:
	return get_node("Erg").get_children()

# Clean objects off screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

# Clean objects and update score
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		if get_node("/root/Main/Player").health >= 0:
			get_node("/root/Main/Player").update_score()
		self.queue_free()
	elif body.is_in_group("Powerup") or body.is_in_group("Bitcoin"):
		self.queue_free()
