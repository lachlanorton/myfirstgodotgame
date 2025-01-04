extends Node
var game_scene = preload("res://scenes/game.tscn").instantiate()
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_play_button_pressed() -> void:
	animation_player.play("hit_button")
	var anim_fin = animation_player.animation_finished
	await(anim_fin)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed() -> void:
	animation_player.play("hit_button")
	var anim_fin = animation_player.animation_finished
	await(anim_fin)
	get_tree().quit()
