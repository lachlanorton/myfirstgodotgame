extends Node2D

const SPEED = 30

var direction = 1

var health = 1
var is_being_hit = false

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction + SPEED * delta

func slimeHit():
	if is_being_hit:
		return
	health -= 1
	if health == 0:
		slimeDied()
	# otherwise play hit animation if slime has more health

func slimeDied():
	self.queue_free()
