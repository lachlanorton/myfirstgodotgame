extends Area2D
@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if self.name == "WorldVoid":
		body.playerDied()
	else:
		body.playerHit()

# death function moved to player.gd
