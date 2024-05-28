extends CharacterBody2D

# Choose 0 or 1
var founder : int = randi_range(0,1)

# Start the powerups randomly
func call_powerup():
	if !founder:
		get_node("Mic").visible = true
		get_node("Whiteboard").visible = false
	else:
		get_node("Mic").visible = false
		get_node("Whiteboard").visible = true
	set_position(Vector2(randf_range(80, 1840), randf_range(80, 1000)))

# Clean objects, play founder sounds and update health
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Bullet"):
		match founder:
			0: $Kushti.play()
			1: $Charles.play()
		if get_node("/root/Main/Player").health > 0:
			get_node("/root/Main/Player").update_health(true)
		$Mic.play("death")
		$Whiteboard.play("death")
		await $Mic.animation_finished
		await $Whiteboard.animation_finished
		match founder:
			0: await $Kushti.finished
			1: await $Charles.finished
		self.queue_free()
