extends CharacterBody2D

const SPEED = 6.9

# Start Bitcoin "breather". The enemy timer will start again after on instance of Powerups
func _on_area_2d_body_entered(body):
	if body.is_in_group("Bullet") or body.is_in_group("Player"):
		get_parent().get_node("EnemyTimer").stop()
		$Bitcoin.play("death")
		$BitcoinSound.play()
		await $Bitcoin.animation_finished
		self.queue_free()
