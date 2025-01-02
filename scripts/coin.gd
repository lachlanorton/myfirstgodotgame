extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(_body: Node2D) -> void:
	pass # Replace with function body.
	# print("+1 coin")
	game_manager.add_point()
	# queue_free()
	animation_player.play("pickup")
