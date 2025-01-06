extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_sword_area_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	if enemy.name == "slime":
		enemy.slimeHit()
	else:
		pass
