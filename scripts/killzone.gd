extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
#	boundaryType = self.get_node("CollisionShape2D")
#	if boundaryType is worldboundary, then body.playerVoid() otherwise body.playerHit()
	if self.name == "WorldVoid":
		body.playerVoid()
	else:
		body.playerHit()

# old death mechanism
# new death mechanism moved to player.gd script

# func _on_body_entered(body: Node2D) -> void:
#	Engine.time_scale = 0.5
#	body.playerDied()
#	body.get_node("CollisionShape2D").queue_free()
#	var death_label = body.get_node("Camera2D/DeathLabel")
#	death_label.visible = true
#	timer.start()

# func _on_timer_timeout() -> void:
#	Engine.time_scale = 1
#	get_tree().reload_current_scene()
