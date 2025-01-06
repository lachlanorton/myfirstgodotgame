extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if self.name.contains("Heal"):
		body.playerHeal()
		animation_player.play("anim_fruit")
